#include <arpa/inet.h>
#include <errno.h>
#include <netdb.h>
#include <netinet/in.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h>
#include "nativeutils.h"

#include "rt.h"

static void on_alarm(int x) {}

int net_socket_connect(int argc, struct descrip *argv) {
    int timeout = 0;
    int n, sd, rc;
    struct hostent *h;
    struct in_addr *addr;
    struct sockaddr_in local_addr, serv_addr;
    static struct sigaction sigact;
    struct b_file *fl;
    struct descrip name;
    char *s;

    if (argc < 3)
        return 101;
    if (!cnv_str(&argv[1], &argv[1])) {
        argv[0] = argv[1];
        return 103;
    }
    if (!cnv_int(&argv[2], &argv[2])) {
        argv[0] = argv[2];
        return 101;
    }
    if (!cnv_int(&argv[3], &argv[3])) {
        argv[0] = argv[3];
        return 101;
    }
    timeout = IntVal(argv[3]) / 1000;

    errno = 0;
    IntVal(amperErrno) = errno;
    n = StrLen(argv[1]);
    s = malloc(n + 1);
    strncpy(s, StrLoc(argv[1]), n);
    s[n] = 0;
    h = gethostbyname(s);
    free(s);
    if (!h)
        return -1;

    addr = (struct in_addr*)StrLoc(argv[1]);
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_addr = *((struct in_addr*)h->h_addr);
    serv_addr.sin_port = htons(IntVal(argv[2]));

    sd = socket(AF_INET, SOCK_STREAM, 0);
    if(sd < 0) {
        IntVal(amperErrno) = errno;
        return -1;
    }

    local_addr.sin_family = AF_INET;
    local_addr.sin_addr.s_addr = htonl(INADDR_ANY);
    local_addr.sin_port = htons(0);

    rc = bind(sd, (struct sockaddr *) &local_addr, sizeof(local_addr));
    if (rc < 0) {
        IntVal(amperErrno) = errno;
        return -1;
    }

    sigact.sa_handler = on_alarm;
    sigact.sa_flags = 0;
    sigfillset(&sigact.sa_mask);
    sigaction(SIGALRM, &sigact, 0);
    alarm(timeout);
    rc = connect(sd, (struct sockaddr *) &serv_addr, sizeof(serv_addr));
    alarm(0);
    if (rc < 0) {
        IntVal(amperErrno) = errno;
        return -1;
    }

    name = create_string(inet_ntoa(*addr));
    fl = alcfile((FILE*)sd, Fs_Write|Fs_Read|Fs_Socket, &name);

    argv->vword.bptr = (union block *)fl;
    argv->dword = D_File;

    return 0;
}

int net_socket_recv(int argc, struct descrip *argv) {
    int sd, rc, timeout = 0;
    size_t len;
    static struct sigaction sigact;
    char *buff;

    if (argc < 3)
        return 101;
    if (argv[1].dword != D_File) {
        argv[0] = argv[1];
        return 105;
    }
    if (!cnv_int(&argv[2], &argv[2])) {
        argv[0] = argv[2];
        return 101;
    }
    if (!cnv_int(&argv[3], &argv[3])) {
        argv[0] = argv[3];
        return 101;
    }

    sd = (int)BlkLoc(argv[1])->file.fd;
    len = (size_t)IntVal(argv[2]);
    timeout = IntVal(argv[3]) / 1000;

    buff = malloc(len);

    sigact.sa_handler = on_alarm;
    sigact.sa_flags = 0;
    sigfillset(&sigact.sa_mask);
    sigaction(SIGALRM, &sigact, 0);
    alarm(timeout);
    errno = 0;
    rc = recv(sd, buff, len, 0);
    alarm(0);
    if (rc <= 0) {
        IntVal(amperErrno) = errno;
        free(buff);
        return -1;
    }

    argv->dword = rc;
    argv->vword.sptr = (char*)alcstr(buff, argv->dword);
    free(buff);

    return 0;
}

int net_socket_send(int argc, struct descrip *argv) {
    int sd, rc, timeout = 0;
    size_t len;
    static struct sigaction sigact;
    char *data;

    if (argc < 3)
        return 101;
    if (argv[1].dword != D_File) {
        argv[0] = argv[1];
        return 105;
    }
    if (!cnv_str(&argv[2], &argv[2])) {
        argv[0] = argv[2];
        return 103;
    }
    if (!cnv_int(&argv[3], &argv[3])) {
        argv[0] = argv[3];
        return 101;
    }

    sd = (int)BlkLoc(argv[1])->file.fd;
    len = (size_t)argv[2].dword;
    data = argv[2].vword.sptr;
    timeout = IntVal(argv[3]) / 1000;

    sigact.sa_handler = on_alarm;
    sigact.sa_flags = 0;
    sigfillset(&sigact.sa_mask);
    sigaction(SIGALRM, &sigact, 0);
    alarm(timeout);
    rc = send(sd, data, len, 0);
    alarm(0);
    if (rc < 0) {
        IntVal(amperErrno) = errno;
        return -1;
    }

    return 0;
}
