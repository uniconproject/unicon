#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/socket.h>
#include <netdb.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <memory.h>
#include <grp.h>
#include <pwd.h>
#include <time.h>

#define BODY_ONLY 1
#define HEADER_ONLY 2
#define FILE_FLAG 3
#define HTTP_FLAG 4

# define BUFLEN 10 * 1024

enum httpcode {OK=200, CREATED=201, ACCEPTED=202, NOCONTENT=204, 
	       MV_PERM=301, MV_TEMP=302, NOT_MOD=304, 
	       BAD=400, UNAUTH=401, FORB=403, NOTFOUND=404, 
	       SERERROR=500, NOT_IMPL=501, BADGATE=502, UNAVAIL=503}; 

struct netfd {
       int flag;	/* indicates local file or http file */
       int s;		/* indicated socket id or file descriptor */
};

struct http_stat {
        enum httpcode scode;     /* status code */ 
        char *location;         /* exact location of the resource */ 
        char *server;           /* info about the software used by the origin server */  
        char *type;             /* media type */ 
        int  length;            /* content length of the file */ 
        char *date;             /* the date and time at which the message originated */ 
        char *last_mod;         /* the last modified date and time */ 
        char *exp_date;         /* expiration date and time */ 
};
 
 
struct netstat { 
       int flag;                /* flag indicating local file or network file */ 
       union { 
        struct stat fbuf;                                                      
        struct http_stat hbuf;   
       } u;
};

FILE * netopen(char *, char *);
FILE * socketopen(char *, char *);
int netstatus(char *, struct netstat *);
int is_url(char *);
char *make_mode(mode_t);
