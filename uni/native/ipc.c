
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <signal.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <sys/sem.h>
#include <sys/msg.h>
#include <sys/types.h>

#include "rt.h"

typedef union {
      int val;
      struct semid_ds *buf;
      unsigned short int *array;
      struct seminfo *__buf;    
} semun;

typedef struct {
      int data_id;
      int data_size;
      int sem_id;
} shm_top;

typedef struct {
      int msg_id;
      int snd_sem_id;
      int rcv_sem_id;
} msg_top;

typedef struct {
      long mtype;
      union {
            char mtext[1];
            int size;
      } u;
} msghead;

typedef struct {
      long mtype;
      char mtext[1024];
} msgblock;

typedef struct {
      int pid;
      int type;
      int id;
} resource;

static int aborted(char *s);
static void cleanup(void);
static void handler(int signo);
static void add_resource(int id, int type);
static void remove_resource(int id, int type);
static int msgsnd_ex(int msqid, void *msgp, size_t msgsz, int msgflg);
static ssize_t msgrcv_ex(int msqid, void *msgp, size_t msgsz, long msgtyp, int msgflg);
static int semop_ex(int semid, struct sembuf *sops, size_t nsops);

#define MAX_RESOURCES 500

static resource resources[MAX_RESOURCES];
static int num_resources = 0;

int shm_open_public(int argc, struct descrip *argv) {
   int top_id;

   if (argc < 1)
      return 101;
   if (!cnv_int(&argv[1], &argv[1])) {
      argv[0] = argv[1];
      return 101;
   }
   top_id = shmget(argv[1].vword.integr, sizeof(shm_top), 0600);
   if (top_id == -1) {
      // ENOENT causes failure; all other errors abort.
      if (errno == ENOENT)
         return -1;
      return aborted("Couldn't get shm id");
   }

   MakeInt(top_id, &argv[0]);

   return 0;
}

int shm_create_public(int argc, struct descrip *argv) {
   int top_id, sem_id, data_id;
   shm_top *tp;
   semun arg;
   void *p, *data;
   int size;

   if (argc < 2)
      return 101;
   if (!cnv_int(&argv[1], &argv[1])) {
      argv[0] = argv[1];
      return 101;
   }
   if (!cnv_str(&argv[2], &argv[2])) {
      argv[0] = argv[2];
      return 103;
   }
   top_id = shmget(argv[1].vword.integr, sizeof(shm_top), IPC_EXCL | IPC_CREAT | 0600);
   if (top_id == -1) {
      // EEXIST causes failure; all other errors abort.
      if (errno == EEXIST)
         return -1;
      return aborted("Couldn't get shm id");
   }
   data = argv[2].vword.sptr;
   size = argv[2].dword;

   tp = (shm_top*)shmat(top_id, 0, 0);
   if ((void*)tp == (void*)-1)
      return aborted("Couldn't attach to shm");

   // Create and initialize the semaphore
   sem_id = semget(IPC_PRIVATE, 1, IPC_CREAT | 0600);
   if (sem_id == -1)
      return aborted("Couldn't get sem id");
   arg.val = 1;
   if (semctl(sem_id, 0, SETVAL, arg) == -1)
      return aborted("Couldn't do semctl");

   // Initialize the data
   data_id = shmget(IPC_PRIVATE, size, IPC_CREAT | 0600);
   if (data_id == -1)
      return aborted("Couldn't get shm id");
   p = shmat(data_id, 0, 0);
   if ((void*)p == (void*)-1)
      return aborted("Couldn't attach to shm");
   memcpy(p, data, size);
   shmdt(p);

   tp->sem_id = sem_id;
   tp->data_id = data_id;
   tp->data_size = size;

   shmdt(tp);

   MakeInt(top_id, &argv[0]);

   return 0;
}

int shm_create_private(int argc, struct descrip *argv) {
   int top_id, sem_id, data_id;
   shm_top *tp;
   semun arg;
   void *p, *data;
   int size;

   if (argc < 1)
      return 101;
   if (!cnv_str(&argv[1], &argv[1])) {
      argv[0] = argv[1];
      return 103;
   }

   top_id = shmget(IPC_PRIVATE, sizeof(shm_top), IPC_CREAT | 0600);
   if (top_id == -1)
      return aborted("Couldn't get shm id");
   data = argv[1].vword.sptr;
   size = argv[1].dword;

   tp = (shm_top*)shmat(top_id, 0, 0);
   if ((void*)tp == (void*)-1)
      return aborted("Couldn't attach to shm");

   // Create and initialize the semaphore
   sem_id = semget(IPC_PRIVATE, 1, IPC_CREAT | 0600);
   if (sem_id == -1)
      return aborted("Couldn't get sem id");
   arg.val = 1;
   if (semctl(sem_id, 0, SETVAL, arg) == -1)
      return aborted("Couldn't do semctl");

   // Initialize the data
   data_id = shmget(IPC_PRIVATE, size, IPC_CREAT | 0600);
   if (data_id == -1)
      return aborted("Couldn't get shm id");
   p = shmat(data_id, 0, 0);
   if ((void*)p == (void*)-1)
      return aborted("Couldn't attach to shm");
   memcpy(p, data, size);
   shmdt(p);

   tp->sem_id = sem_id;
   tp->data_id = data_id;
   tp->data_size = size;

   shmdt(tp);

   add_resource(top_id, 0);

   MakeInt(top_id, &argv[0]);
   return 0;
}

int shm_remove(int argc, struct descrip *argv) {
   int top_id;
   shm_top *tp;

   if (argc < 1)
      return 101;
   if (!cnv_int(&argv[1], &argv[1])) {
      argv[0] = argv[1];
      return 101;
   }
   top_id = IntVal(argv[1]);
   tp = (shm_top*)shmat(top_id, 0, 0);
   if ((void*)tp == (void*)-1)
      return aborted("Couldn't attach to shm");

   shmctl(tp->data_id, IPC_RMID, 0);
   semctl(tp->sem_id, -1, IPC_RMID, 0);
   shmctl(top_id, IPC_RMID, 0);
   shmdt(tp);
   remove_resource(top_id, 0);

   return 0;
}

int shm_set_value(int argc, struct descrip *argv) {
   int top_id;
   shm_top *tp;
   char *data;
   int size;
   struct sembuf p_buf;
   struct shmid_ds shminfo;

   if (argc < 2)
      return 101;
   if (!cnv_int(&argv[1], &argv[1])) {
      argv[0] = argv[1];
      return 101;
   }
   if (!cnv_str(&argv[2], &argv[2])) {
      argv[0] = argv[2];
      return 103;
   }
   top_id = IntVal(argv[1]);
   tp = (shm_top*)shmat(top_id, 0, 0);
   if ((void*)tp == (void*)-1)
      return aborted("Couldn't attach to shm");
   data = argv[2].vword.sptr;
   size = argv[2].dword;

   // Wait
   p_buf.sem_num = 0;
   p_buf.sem_op = -1;
   p_buf.sem_flg = SEM_UNDO;
   if (semop_ex(tp->sem_id, &p_buf, 1) == -1)
      return aborted("wait failed");

   shmctl(tp->data_id, IPC_STAT, &shminfo);
   if (size <= shminfo.shm_segsz) {
      // New data will fit in current space
      void *p;
      tp->data_size = size;
      p = shmat(tp->data_id, 0, 0);
      if ((void*)p == (void*)-1)
         return aborted("Couldn't attach to shm");
      memcpy(p, data, size);
      shmdt(p);
   } else {
      // Size too small, get rid of old and reallocate.
      int data_id;
      void *p;
      shmctl(tp->data_id, IPC_RMID, 0);
      // Allocate new data and copy
      data_id = shmget(IPC_PRIVATE, size, IPC_CREAT | 0600);
      if (data_id == -1)
         return aborted("Couldn't get shm id");
      p = shmat(data_id, 0, 0);
      if ((void*)p == (void*)-1)
         return aborted("Couldn't attach to shm");
      memcpy(p, data, size);
      shmdt(p);

      tp->data_id = data_id;
      tp->data_size = size;
   }
   
   // Signal
   p_buf.sem_op = 1;
   if (semop_ex(tp->sem_id, &p_buf, 1) == -1)
      return aborted("signal failed");
   
   shmdt(tp);
   return 0;
}

int shm_get_value(int argc, struct descrip *argv) {
   int top_id;
   shm_top *tp;
   char *data;
   struct sembuf p_buf;

   if (argc < 1)
      return 101;
   if (!cnv_int(&argv[1], &argv[1])) {
      argv[0] = argv[1];
      return 101;
   }
   top_id = IntVal(argv[1]);
   tp = (shm_top*)shmat(top_id, 0, 0);
   if ((void*)tp == (void*)-1)
      return aborted("Couldn't attach to shm");

   // Wait
   p_buf.sem_num = 0;
   p_buf.sem_op = -1;
   p_buf.sem_flg = SEM_UNDO;
   if (semop_ex(tp->sem_id, &p_buf, 1) == -1)
      return aborted("wait failed");

   data = (char*)shmat(tp->data_id, 0, 0);
   if ((void*)data == (void*)-1)
      return aborted("Couldn't attach to shm");

   argv->dword = tp->data_size;
   argv->vword.sptr = (char*)alcstr(data, argv->dword);
   shmdt(data);

   // Signal
   p_buf.sem_op = 1;
   if (semop_ex(tp->sem_id, &p_buf, 1) == -1)
      return aborted("signal failed");

   shmdt(tp);
   return 0;
}

int sem_open_public(int argc, struct descrip *argv) {
   int sem_id;

   if (argc < 1)
      return 101;
   if (!cnv_int(&argv[1], &argv[1])) {
      argv[0] = argv[1];
      return 101;
   }

   sem_id = semget(argv[1].vword.integr, 0, 0600);
   if (sem_id == -1) {
      // ENOENT causes failure; all other errors abort.
      if (errno == ENOENT)
         return -1;
      return aborted("Couldn't get sem id");
   }

   MakeInt(sem_id, &argv[0]);

   return 0;
}

int sem_create_public(int argc, struct descrip *argv) {
   int sem_id;
   semun arg;

   if (argc < 2)
      return 101;

   if (!cnv_int(&argv[1], &argv[1])) {
      argv[0] = argv[1];
      return 101;
   }
   if (!cnv_int(&argv[2], &argv[2])) {
      argv[0] = argv[2];
      return 101;
   }
   arg.val = IntVal(argv[2]);

   sem_id = semget(argv[1].vword.integr, 1, IPC_EXCL | IPC_CREAT | 0600);
   if (sem_id == -1) {
      // EEXIST causes failure; all other errors abort.
      if (errno == EEXIST)
         return -1;
      return aborted("Couldn't get sem id");
   }

   // Set the initial value
   if (semctl(sem_id, 0, SETVAL, arg) == -1)
      return aborted("Couldn't do semctl");

   MakeInt(sem_id, &argv[0]);

   return 0;
}

int sem_create_private(int argc, struct descrip *argv) {
   int sem_id;
   semun arg;

   if (argc < 1)
      return 101;

   if (!cnv_int(&argv[1], &argv[1])) {
      argv[0] = argv[1];
      return 101;
   }
   arg.val = IntVal(argv[1]);

   sem_id = semget(IPC_PRIVATE, 1, IPC_CREAT | 0600);
   if (sem_id == -1)
      return aborted("Couldn't get sem id");

   add_resource(sem_id, 1);

   // Set the initial value
   if (semctl(sem_id, 0, SETVAL, arg) == -1)
      return aborted("Couldn't do semctl");

   MakeInt(sem_id, &argv[0]);

   return 0;
}

int sem_set_value(int argc, struct descrip *argv) {
   int sem_id;
   semun arg;

   if (argc < 2)
      return 101;
   if (!cnv_int(&argv[1], &argv[1])) {
      argv[0] = argv[1];
      return 101;
   }
   if (!cnv_int(&argv[2], &argv[2])) {
      argv[0] = argv[2];
      return 101;
   }
   sem_id = IntVal(argv[1]);

   arg.val = IntVal(argv[2]);
   if (semctl(sem_id, 0, SETVAL, arg) == -1)
      return aborted("Couldn't do semctl");

   return 0;
}

int sem_get_value(int argc, struct descrip *argv) {
   int sem_id;
   int ret;
   semun arg;

   if (argc < 1)
      return 101;
   if (!cnv_int(&argv[1], &argv[1])) {
      argv[0] = argv[1];
      return 101;
   }
   sem_id = IntVal(argv[1]);

   ret = semctl(sem_id, 0, GETVAL, arg);
   if (ret == -1)
      return aborted("Couldn't do semctl");

   MakeInt(ret, &argv[0]);

   return 0;
}

int sem_semop(int argc, struct descrip *argv) {
   int sem_id;
   struct sembuf p_buf;

   if (argc < 2)
      return 101;
   if (!cnv_int(&argv[1], &argv[1])) {
      argv[0] = argv[1];
      return 101;
   }
   if (!cnv_int(&argv[2], &argv[2])) {
      argv[0] = argv[2];
      return 101;
   }
   sem_id = IntVal(argv[1]);
   
   p_buf.sem_num = 0;
   p_buf.sem_op = IntVal(argv[2]);
   p_buf.sem_flg = SEM_UNDO;
   if (semop_ex(sem_id, &p_buf, 1) == -1)
      return aborted("semop failed");

   return 0;
}

int sem_semop_nowait(int argc, struct descrip *argv) {
   int sem_id;
   struct sembuf p_buf;

   if (argc < 2)
      return 101;
   if (!cnv_int(&argv[1], &argv[1])) {
      argv[0] = argv[1];
      return 101;
   }
   if (!cnv_int(&argv[2], &argv[2])) {
      argv[0] = argv[2];
      return 101;
   }
   sem_id = IntVal(argv[1]);
   
   p_buf.sem_num = 0;
   p_buf.sem_op = IntVal(argv[2]);
   p_buf.sem_flg = SEM_UNDO | IPC_NOWAIT;
   if (semop_ex(sem_id, &p_buf, 1) == -1) {
      if (errno == EAGAIN)
         // Okay, it's not ready,so fail
         return -1;
      // A runtime error.
      return aborted("semop failed");
   }
   return 0;
}

int sem_remove(int argc, struct descrip *argv) {
   int sem_id;

   if (argc < 1)
      return 101;
   if (!cnv_int(&argv[1], &argv[1])) {
      argv[0] = argv[1];
      return 101;
   }
   sem_id = IntVal(argv[1]);

   semctl(sem_id, -1, IPC_RMID, 0);

   remove_resource(sem_id, 1);

   return 0;
}

int msg_open_public(int argc, struct descrip *argv) {
   int top_id;

   if (argc < 1)
      return 101;
   if (!cnv_int(&argv[1], &argv[1])) {
      argv[0] = argv[1];
      return 101;
   }

   top_id = shmget(argv[1].vword.integr, sizeof(msg_top), 0600);
   if (top_id == -1) {
      // ENOENT causes failure; all other errors abort.
      if (errno == ENOENT)
         return -1;
      return aborted("Couldn't get top id");
   }

   MakeInt(top_id, &argv[0]);

   return 0;
}

int msg_create_public(int argc, struct descrip *argv) {
   int top_id, msg_id, rcv_sem_id, snd_sem_id;
   msg_top *tp;
   semun arg;

   if (argc < 1)
      return 101;

   if (!cnv_int(&argv[1], &argv[1])) {
      argv[0] = argv[1];
      return 101;
   }
   top_id = shmget(argv[1].vword.integr, sizeof(msg_top), IPC_EXCL | IPC_CREAT | 0600);
   if (top_id == -1) {
      // EEXIST causes failure; all other errors abort.
      if (errno == EEXIST)
         return -1;
      return aborted("Couldn't get shm id");
   }

   tp = (msg_top*)shmat(top_id, 0, 0);
   if ((void*)tp == (void*)-1)
      return aborted("Couldn't attach to shm");

   msg_id = msgget(IPC_PRIVATE, IPC_CREAT | 0600);
   if (msg_id == -1)
      return aborted("Couldn't get msg id");

   // Create and initialize the semaphores
   rcv_sem_id = semget(IPC_PRIVATE, 1, IPC_CREAT | 0600);
   if (rcv_sem_id == -1)
      return aborted("Couldn't get sem id");
   arg.val = 1;
   if (semctl(rcv_sem_id, 0, SETVAL, arg) == -1)
      return aborted("Couldn't do semctl");
   snd_sem_id = semget(IPC_PRIVATE, 1, IPC_CREAT | 0600);
   if (snd_sem_id == -1)
      return aborted("Couldn't get sem id");
   arg.val = 1;
   if (semctl(snd_sem_id, 0, SETVAL, arg) == -1)
      return aborted("Couldn't do semctl");

   // Initialize the top data
   tp->msg_id = msg_id;
   tp->snd_sem_id = snd_sem_id;
   tp->rcv_sem_id = rcv_sem_id;
   shmdt(tp);

   MakeInt(top_id, &argv[0]);

   return 0;
}

int msg_create_private(int argc, struct descrip *argv) {
   int top_id, msg_id, rcv_sem_id, snd_sem_id;
   msg_top *tp;
   semun arg;

   top_id = shmget(IPC_PRIVATE, sizeof(msg_top), IPC_CREAT | 0600);
   if (top_id == -1)
      return aborted("Couldn't get shm id");
   tp = (msg_top*)shmat(top_id, 0, 0);
   if ((void*)tp == (void*)-1)
      return aborted("Couldn't attach to shm");

   msg_id = msgget(IPC_PRIVATE, IPC_CREAT | 0600);
   if (msg_id == -1)
      return aborted("Couldn't get msg id");

   // Create and initialize the semaphores
   rcv_sem_id = semget(IPC_PRIVATE, 1, IPC_CREAT | 0600);
   if (rcv_sem_id == -1)
      return aborted("Couldn't get sem id");
   arg.val = 1;
   if (semctl(rcv_sem_id, 0, SETVAL, arg) == -1)
      return aborted("Couldn't do semctl");
   snd_sem_id = semget(IPC_PRIVATE, 1, IPC_CREAT | 0600);
   if (snd_sem_id == -1)
      return aborted("Couldn't get sem id");
   arg.val = 1;
   if (semctl(snd_sem_id, 0, SETVAL, arg) == -1)
      return aborted("Couldn't do semctl");

   // Initialize the top data
   tp->msg_id = msg_id;
   tp->snd_sem_id = snd_sem_id;
   tp->rcv_sem_id = rcv_sem_id;
   shmdt(tp);

   add_resource(top_id, 2);

   MakeInt(top_id, &argv[0]);

   return 0;
}

int msg_remove(int argc, struct descrip *argv) {
   int top_id;
   msg_top *tp;

   if (argc < 1)
      return 101;
   if (!cnv_int(&argv[1], &argv[1])) {
      argv[0] = argv[1];
      return 101;
   }
   top_id = IntVal(argv[1]);
   tp = (msg_top*)shmat(top_id, 0, 0);
   if ((void*)tp == (void*)-1)
      return aborted("Couldn't attach to shm");

   semctl(tp->rcv_sem_id, -1, IPC_RMID, 0);
   semctl(tp->snd_sem_id, -1, IPC_RMID, 0);
   msgctl(tp->msg_id, IPC_RMID, 0);
   shmctl(top_id, IPC_RMID, 0);
   shmdt(tp);
   remove_resource(top_id, 2);

   return 0;
}

int msg_send(int argc, struct descrip *argv) {
   int top_id;
   msg_top *tp;
   char *data;
   msghead mh;
   msgblock mb;
   struct sembuf p_buf;
   int size, blocks, i, residue;

   if (argc < 2)
      return 101;
   if (!cnv_int(&argv[1], &argv[1])) {
      argv[0] = argv[1];
      return 101;
   }
   if (!cnv_str(&argv[2], &argv[2])) {
      argv[0] = argv[2];
      return 103;
   }
   top_id = IntVal(argv[1]);
   tp = (msg_top*)shmat(top_id, 0, 0);
   if ((void*)tp == (void*)-1)
      return aborted("Couldn't attach to shm");

   data = argv[2].vword.sptr;
   size = argv[2].dword;
   //printf("%d snd size=%d\n",getpid(),size);

   // Wait on send semaphore
   p_buf.sem_num = 0;
   p_buf.sem_op = -1;
   p_buf.sem_flg = SEM_UNDO;
   if (semop_ex(tp->snd_sem_id, &p_buf, 1) == -1)
      return aborted("wait failed");

   mh.u.size = size;
   mh.mtype = 1;
   if (msgsnd_ex(tp->msg_id, &mh, sizeof(mh.u), 0) == -1)
      return aborted("Failed to do header msgsnd");

   blocks = size / sizeof(mb.mtext);
   mb.mtype = 1;
   for (i = 0; i < blocks; ++i) {
      memcpy(mb.mtext, data, sizeof(mb.mtext));
      data += sizeof(mb.mtext);
      if (msgsnd_ex(tp->msg_id, &mb, sizeof(mb.mtext), 0) == -1)
         return aborted("Failed to do block msgsnd");
   }
   residue = size % sizeof(mb.mtext);
   if (residue > 0) {
      memcpy(mb.mtext, data, residue);
      if (msgsnd_ex(tp->msg_id, &mb, sizeof(mb.mtext), 0) == -1)
         return aborted("Failed to do resid block msgsnd");
   }

   // Signal
   p_buf.sem_op = 1;
   if (semop_ex(tp->snd_sem_id, &p_buf, 1) == -1)
      return aborted("signal failed");

   //printf("%d snd done\n",getpid());
   
   shmdt(tp);
   return 0;
}

int msg_receive(int argc, struct descrip *argv) {
   int top_id;
   msg_top *tp;
   int size, blocks, residue, i;
   struct sembuf p_buf;
   msghead mh;
   msgblock mb;
   char *data, *p;

   if (argc < 1)
      return 101;
   if (!cnv_int(&argv[1], &argv[1])) {
      argv[0] = argv[1];
      return 101;
   }
   top_id = IntVal(argv[1]);
   tp = (msg_top*)shmat(top_id, 0, 0);
   if ((void*)tp == (void*)-1)
      return aborted("Couldn't attach to shm");

   // Wait on rcv semaphore
   p_buf.sem_num = 0;
   p_buf.sem_op = -1;
   p_buf.sem_flg = SEM_UNDO;
   if (semop_ex(tp->rcv_sem_id, &p_buf, 1) == -1)
      return aborted("wait failed");

   if (msgrcv_ex(tp->msg_id, &mh, sizeof(mh.u), 0, 0) == -1) {
      return aborted("Failed to do header msgrcv");
   }
   size = mh.u.size;
   blocks = size / sizeof(mb.mtext);
   //printf("%d rcv size=%d\n",getpid(),size);
   p = data = malloc(size);
   
   for (i = 0; i < blocks; ++i) {
      if (msgrcv_ex(tp->msg_id, &mb, sizeof(mb.mtext), 0, 0) == -1)
         return aborted("Failed to do block msgrcv");
      memcpy(data, mb.mtext, sizeof(mb.mtext));
      data += sizeof(mb.mtext);
   }
   residue = size % sizeof(mb.mtext);
   if (residue > 0) {
      if (msgrcv_ex(tp->msg_id, &mb, sizeof(mb.mtext), 0, 0) == -1)
         return aborted("Failed to do resid block msgrcv");
      memcpy(data, mb.mtext, residue);
   }

   argv->dword = size;
   argv->vword.sptr = (char*)alcstr(p, argv->dword);
   free(p);

   // Signal
   p_buf.sem_op = 1;
   if (semop_ex(tp->rcv_sem_id, &p_buf, 1) == -1)
      return aborted("signal failed");
   
   shmdt(tp);

   return 0;
}

int msg_receive_nowait(int argc, struct descrip *argv) {
   int top_id;
   msg_top *tp;
   int size, blocks, residue, i;
   struct sembuf p_buf;
   msghead mh;
   msgblock mb;
   char *data, *p;

   if (argc < 1)
      return 101;
   if (!cnv_int(&argv[1], &argv[1])) {
      argv[0] = argv[1];
      return 101;
   }
   top_id = IntVal(argv[1]);
   tp = (msg_top*)shmat(top_id, 0, 0);
   if ((void*)tp == (void*)-1)
      return aborted("Couldn't attach to shm");

   // Wait on rcv semaphore
   p_buf.sem_num = 0;
   p_buf.sem_op = -1;
   p_buf.sem_flg = SEM_UNDO;

   if (semop_ex(tp->rcv_sem_id, &p_buf, 1) == -1)
      return aborted("wait failed");
   if (msgrcv_ex(tp->msg_id, &mh, sizeof(mh.u), 0, IPC_NOWAIT) == -1) {
      if (errno == ENOMSG) {
         // Okay, it's not ready,so fail.  First signal.
         p_buf.sem_op = 1;
         if (semop_ex(tp->rcv_sem_id, &p_buf, 1) == -1)
            return aborted("signal failed");
         return -1;
      }
      return aborted("Failed to do header msgrcv");
   }
   size = mh.u.size;
   blocks = size / sizeof(mb.mtext);

   p = data = malloc(size);
   
   for (i = 0; i < blocks; ++i) {
      if (msgrcv_ex(tp->msg_id, &mb, sizeof(mb.mtext), 0, 0) == -1)
         return aborted("Failed to do block msgrcv");
      memcpy(data, mb.mtext, sizeof(mb.mtext));
      data += sizeof(mb.mtext);
   }
   residue = size % sizeof(mb.mtext);
   if (residue > 0) {
      if (msgrcv_ex(tp->msg_id, &mb, sizeof(mb.mtext), 0, 0) == -1)
         return aborted("Failed to do resid block msgrcv");
      memcpy(data, mb.mtext, residue);
   }

   argv->dword = size;
   argv->vword.sptr = (char*)alcstr(p, argv->dword);
   free(p);

   // Signal
   p_buf.sem_op = 1;
   if (semop_ex(tp->rcv_sem_id, &p_buf, 1) == -1)
      return aborted("signal failed");
   
   shmdt(tp);

   return 0;
}

/*
 * These wrappers are needed because msgsnd, msgrcv and semop return
 * -1 (errno=EINTR) if a signal is received during execution.  In
 * particular, SIGPROF seems to do this.  Setting SA_RESTART on the
 * handler's flags doesn't seem to work.  Ignoring the signal does
 * work, but that prevents anyone else actually trapping the signal.
 */

static int msgsnd_ex(int msqid, void *msgp, size_t msgsz, int msgflg) {
   int i;

   do {
      i = msgsnd(msqid, msgp, msgsz, msgflg);
   } while (i == -1 && errno == EINTR);

   return i;
}

static ssize_t msgrcv_ex(int msqid, void *msgp, size_t msgsz, long msgtyp, int msgflg) {
   ssize_t i;

   do {
      i = msgrcv(msqid, msgp, msgsz, msgtyp, msgflg);
   } while (i == -1 && errno == EINTR);

   return i;
}

static int semop_ex(int semid, struct sembuf *sops, size_t nsops) {
   int i;

   do {
      i = semop(semid, sops, nsops);
   } while (i == -1 && errno == EINTR);

   return i;
}

static void add_resource(int id, int type) {
   static int inited = 0;
   int i;

   if (!inited) {
      struct sigaction sigact;

      // Signals to handle
      sigact.sa_handler = handler;
      sigact.sa_flags = 0;
      sigfillset(&sigact.sa_mask);
      sigaction(SIGINT, &sigact, 0);
      sigaction(SIGTERM, &sigact, 0);

      atexit(cleanup);
      inited = 1;
   }

   for (i = 0; i < num_resources; ++i) {
      if (resources[i].pid == -1) {
         resources[i].pid = getpid();
         resources[i].type = type;
         resources[i].id = id;
         return;
      }
   }
   if (num_resources >= MAX_RESOURCES)
      return;
   resources[num_resources].pid = getpid();
   resources[num_resources].type = type;
   resources[num_resources].id = id;
   ++num_resources;
}

static void remove_resource(int id, int type) {
   int i;
   for (i = 0; i < num_resources; ++i) {
      if (resources[i].type == type && resources[i].id == id) {
         resources[i].pid = -1;
         return;
      }
   }
}

static int aborted(char *s) {
   fprintf(stderr, "Unexpected problem: %s; program will abort\n", s);
   return 1001;
}

static void cleanup() {
   int pid;
   int i;

   //printf("in cleanup pid=%d\n", getpid());
   pid = getpid();
   for (i = 0; i < num_resources; ++i) {
      if (resources[i].pid == pid) {
         fprintf(stderr, "Removing resource type %d id=%d\n", resources[i].type, resources[i].id);
         switch (resources[i].type) {
            case 0: {
               shm_top *tp = (shm_top*)shmat(resources[i].id, 0, 0);
               if ((void*)tp == (void*)-1)
                  break;
               shmctl(tp->data_id, IPC_RMID, 0);
               semctl(tp->sem_id, -1, IPC_RMID, 0);
               shmctl(resources[i].id, IPC_RMID, 0);
               shmdt(tp);
               break;
            }
            case 1:
               semctl(resources[i].id, -1, IPC_RMID, 0);
               break;
            case 2: {
               msg_top *tp = (msg_top*)shmat(resources[i].id, 0, 0);
               if ((void*)tp == (void*)-1)
                  break;
               semctl(tp->rcv_sem_id, -1, IPC_RMID, 0);
               semctl(tp->snd_sem_id, -1, IPC_RMID, 0);
               msgctl(tp->msg_id, IPC_RMID, 0);
               shmctl(resources[i].id, IPC_RMID, 0);
               shmdt(tp);
               break;
            }
         }
         resources[i].pid = -1;
      }
   }
   
}

static void handler(int signo) {
   cleanup();
   exit(1);
}
