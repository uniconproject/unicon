// C++ API Functions for unicon
// 2 - 15 - 2005
// Ziad Al-Sharif
// email: zsharif@cs.uidaho.edu

#include "jvoipsession.h"
#include "jvoiprtptransmission.h"
#include "jvoipsessionparams.h"

#ifndef WIN32
        #include "jvoipsoundcardparams.h"
        #include<netdb.h>
#endif

#include "jvoiperrors.h"
#include <stdio.h>

#ifndef WIN32
        #include <arpa/inet.h>
        #include <netinet/in.h>
#endif

#include <stdlib.h>
#include <string.h>

#define print_out 0
//----------------------------------------------

enum { FALSE=0, TRUE=1};

struct LISTENER{
        char *name;     /*   [20]; */
        char *address;  /*   [30]; */
        char *port;     /*   [10]; */
        unsigned long iaddress;
        int iport;
};


/* This struct represents the main components required
 * for establishing and managing the VoIP Session.
 */
 extern "C" struct VOIPSession;
 typedef struct VOIPSession VSESSION;
 typedef struct VOIPSession* PVSESSION;

//----------------------------------------------
#ifdef WIN32
/* this is just for starting up windows sockets*/
extern "C" int StartupWinSocket(void)
{
        WSADATA wsa_data;
        if(WSAStartup(MAKEWORD(1,1),&wsa_data)!= 0){
                 printf("\n StartupWinSocket : WSAStartup Fails");
                 return 0;
        }
        return 1;
}

/* this is just for clossing windows sockets */
extern "C" int CleanupWinSocket(void)
{
        if(WSACleanup()==SOCKET_ERROR){
                printf("\n CleanupWinSocket : Can not sign off from the Windows Sockeet API ");
                return 0;
        }
        return 1;
}
#endif
//----------------------------------------------

void InitList(PVSESSION VSession);
void DestroyList(PVSESSION VSession);
int IsEmpty(PVSESSION VSession);
int IsFull(PVSESSION VSession);
int IsInVList(PVSESSION VSession, char dest[]);

extern "C" char * FetchListener(PVSESSION VSession, int pos);
extern "C" char * FetchName(PVSESSION VSession, int pos);
extern "C" char * FetchAddress(PVSESSION VSession, int pos);
extern "C" int GetVListSize(PVSESSION VSession);

void IncreaseList(PVSESSION VSession);
int AddToList(PVSESSION VSession, char Destination[]);
void DeleteFromList(PVSESSION VSession, int i);
void PrintWhoInVList(PVSESSION VSession);



struct LISTENER * GetListenerInfo(char Destination[]);
int AddListener(PVSESSION VSession, struct LISTENER * Listener);
int DropListener(PVSESSION VSession, struct LISTENER * Listener);
void Cast(PVSESSION VSession, char Destinations[]);
void DropCast(PVSESSION VSession, char Destinations[]);
int InitVoiceSession(PVSESSION VSession, char SessionPort[5]);

extern "C" PVSESSION CreateVoiceSession(char SessionPort[5] , char Destinations[] );
extern "C" void CloseVoiceSession(PVSESSION VSession);

int GetCommand(char Command[]);
char * GetDestinations(char Command[]);

extern "C" void SetVoiceAttrib(PVSESSION VSession, char StrAttrib[]);

