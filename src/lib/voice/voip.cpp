// C++ API Functions for unicon
// 2 - 15 - 2005
// Ziad Al-Sharif
// email: zsharif@cs.uidaho.edu

#include "voip.h"

#ifndef WIN32
        /* for linux data type, espacially OSS */
        struct VOIPSession{
                JVOIPSession                    Session;        /* The main Session */
                JVOIPSessionParams              sessparams;     /* The Session Parameters */
                JVOIPRTPTransmissionParams      rtpparams;      /* The Real Time Protocol Parameters */
                JVOIPSoundcardParams sndinparams;
                JVOIPSoundcardParams sndoutparams;      /* ? */
                int MaxList;
                int InList; // holds the index of the last element in the list.
                char **ListenerList;
        };
#else
        /* for windows data type */
        struct VOIPSession{
                JVOIPSession                    Session;        /* The main Session */
                JVOIPSessionParams              sessparams;     /* The Session Parameters */
                JVOIPRTPTransmissionParams      rtpparams;      /* The Real Time Protocol Parameters */
                int MaxList;
                int InList;
                char ** ListenerList;
        };
#endif

//----------------------------------------------
void InitList(PVSESSION VSession)
{
        int i;
        VSession->MaxList= 100;
        VSession->InList= -1;   /* the list is empty */
        VSession->ListenerList=(char**) calloc(VSession->MaxList,sizeof(char*));

        for(i=0; i< VSession->MaxList ; ++i)
                VSession->ListenerList[i]= NULL;

}
//----------------------------------------------
void DestroyList(PVSESSION VSession)
{
        for(int i=0; i< VSession->MaxList ; ++i)
                if( VSession->ListenerList[i] != NULL)
                        free(VSession->ListenerList[i]);
        free(VSession->ListenerList);
}
//----------------------------------------------
int IsEmpty(PVSESSION VSession)
{
        if(VSession->InList == -1)      return TRUE;
        else                            return FALSE;
}
//----------------------------------------------
int IsFull(PVSESSION VSession)
{
        if(VSession->InList >= (VSession->MaxList-1) )  return TRUE;
        else                                            return FALSE;
}
//----------------------------------------------
int IsInVList(PVSESSION VSession, char dest[])
{
        //printf("\n IsInVList : --------------dest=[%s]\n",dest);
        if( ! IsEmpty(VSession)){
                for(int i=0; i <= VSession->InList; ++i){
                        if(VSession->ListenerList[i] != NULL){
                                if( strstr(VSession->ListenerList[i],dest)){
                                        return i;
                                }
                        }
                }
                return -1;
        }else{
                //printf("\n IsInVList : -------------The List Is Empty !!!\n");
                return -1;
        }
}
//----------------------------------------------
char * FetchListener(PVSESSION VSession, int pos)
{
        if( ! IsEmpty(VSession) ){
                if(VSession->ListenerList[pos] != NULL)
                        return VSession->ListenerList[pos];
                else
                        return NULL;
        }
        else
                return NULL;
}
//----------------------------------------------
char * FetchName(PVSESSION VSession, int pos)
{
        char str[20],*name=NULL,*sp=NULL;
        int i=0;
        if( ! IsEmpty(VSession) ){
                if(VSession->ListenerList[pos] != NULL){
                        sp = VSession->ListenerList[pos];
                        for( ; ((*sp != ':') && (i<20)) ; i++,sp++)
                                str[i]=*sp;
                        str[i]='\0';
                        name= (char*) malloc(i+2);
                        strcpy(name,str);
                        return name;
                }else
                        return NULL;
        }
        else
                return NULL;
}
//----------------------------------------------
char * FetchAddress(PVSESSION VSession, int pos)
{
        char str[40],*address=NULL,*sp=NULL;
        int i=0;
        if( ! IsEmpty(VSession) ){
                if(VSession->ListenerList[pos] != NULL){
                        sp = strchr(VSession->ListenerList[pos],':')+1;
                        for(; (*sp != '\0') && (i<40) ; i++, sp++)
                                str[i]=*sp;
                        str[i]='\0';
                        address= (char*) malloc(i+2);
                        strcpy(address,str);
                        return address;
                }else
                        return NULL;
        }
        else
                return NULL;
}
//----------------------------------------------
void IncreaseList(PVSESSION VSession)
{
        int i;
        VSession->MaxList=VSession->MaxList * 2;
        char ** NewList=NULL;
        NewList = (char**) calloc(VSession->MaxList,sizeof(char*));

        for(i=0; i< VSession->InList ; ++i)
                NewList[i]= VSession->ListenerList[i];

        for(; i< VSession->MaxList ; ++i)
                NewList[i]= NULL;

        free(VSession->ListenerList);
        VSession->ListenerList = NewList;

}
//----------------------------------------------
int AddToList(PVSESSION VSession, char *Dest)
{
        //printf("\n AddToList: [1] ");
        //Dest is preallocated
        int i;
        if( IsEmpty(VSession)){
                VSession->InList = VSession->InList + 1;
                VSession->ListenerList[VSession->InList]= Dest;
                return TRUE;
        }
        else{
                if(! IsFull(VSession) ){
                        for(i=0; i<= VSession->InList ; ++i){
                                if(VSession->ListenerList[i]==NULL){
                                        VSession->ListenerList[i]= Dest;
                                        return TRUE;
                                }
                        }
                        VSession->InList = VSession->InList + 1;
                        VSession->ListenerList[VSession->InList]= Dest;
                        if( IsFull(VSession) )  IncreaseList(VSession);         // for future addition
                        return TRUE;
                }
                return FALSE;
        }// End else
        return FALSE;
}
//----------------------------------------------
void DeleteFromList(PVSESSION VSession, int i)
{
        //printf("\n DeleteFromList : [1] ");
        free(VSession->ListenerList[i]);
        VSession->ListenerList[i]=NULL;
        if(VSession->InList == i)
                VSession->InList = VSession->InList -1;
                /*while((VSession->InList >= 0) && (VSession->ListenerList[i]==NULL))
                        VSession->InList = VSession->InList -1;*/
}
//----------------------------------------------
void PrintWhoInVList(PVSESSION VSession)
{
        int i;
        if( ! IsEmpty(VSession) ){
                printf("\n PrintWhoInVList : The Listener List has [%d] member('s)",VSession->InList+1);
                for(i=0; i<= VSession->InList; ++i)
                        printf("\n PrintWhoInVList : ListenerList[%d]= %s ",i,VSession->ListenerList[i]);
        }
        else
                printf("\n PrintWhoInVList : ListenerList[] Is Empty !!!");
}
//----------------------------------------------
int GetVListSize(PVSESSION VSession)
{
        return VSession->InList;
}
//----------------------------------------------
// Destination will be in the form of userID:IPAddress:Port
struct LISTENER * GetListenerInfo(char *Destination)
{
        //printf("\n GetListenerInfo: [1]  ");
        //unsigned long IP;
        //char IPaddress[30];

        struct hostent *h=NULL;
        int i=0;
        char *sp1=NULL,*sp2=NULL;
        char destip[30];

        //printf("\n GetListenerInfo: [2]  ");

        struct LISTENER * Listener=NULL;
        Listener = (struct LISTENER *) malloc(sizeof(struct LISTENER));
        Listener->name    = (char*) malloc(20 * sizeof(char));
        Listener->address = (char*) malloc(30 * sizeof(char));
        Listener->port    = (char*) malloc(10 * sizeof(char));
        //----------------------------------------------------------

        sp1 = Destination;
        sp2 = strchr(Destination,':');

        for(i=0; sp1<sp2 ; ++i, ++sp1)
                Listener->name[i]=*sp1;
        Listener->name[i]='\0';

        //printf("\n GetListenerInfo: [3]  ");

        sp1=sp2+1;

        sp2=strrchr(Destination,':');
        for(i=0; sp1<sp2 ; ++i, ++sp1)
                Listener->address[i]=*sp1;
        Listener->address[i]='\0';

        //printf("\n GetListenerInfo: [4]  ");

        sp1=sp2+1;
        for(i=0; *sp1 != '\0' ; ++i, ++sp1)
                Listener->port[i]=*sp1;
        Listener->port[i]='\0';
        //----------------------------------
        if( isalpha(Listener->address[0])){
                h = gethostbyname(Listener->address);
                if(print_out) printf("\n ----------------------------------------------->");
                if(print_out) printf("\n GetIPAddress : The host name is      [%s]",h->h_name);
                sprintf(destip,"%d.%d.%d.%d",h->h_addr[0],h->h_addr[1],h->h_addr[2],h->h_addr[3]);
                if(print_out) printf("\n GetIPAddress : destip = [%s]",destip);
                if(print_out) printf("\n ----------------------------------------------->");
                Listener->iaddress= ntohl(inet_addr( Listener->address ));
        }
        else{
                Listener->iaddress= ntohl(inet_addr( Listener->address ));
                //strcpy(Listener->address,IPaddress);
                //Listener->iaddress= IP;
                //Listener->iaddress= ntohl(inet_addr( Listener->address )); // cassing a memory violation
        }
        //----------------------------------
        //printf("\n GetListenerInfo: [5]  ");

        sscanf(Listener->port ,"%d",&Listener->iport);

        printf("\n---------------------------------------------");
        printf("\n Destination       = [%s]",Destination        );
        printf("\n Listener->name    = [%s]",Listener->name     );
        printf("\n Listener->address = [%s]",Listener->address  );
        printf("\n Listener->iaddress= [%ul]",Listener->iaddress);
        printf("\n Listener->port    = [%s]",Listener->port     );
        printf("\n Listener->iport   = [%d]",Listener->iport    );
        printf("\n-------------------------------------------\n");
        return Listener;
}
//----------------------------------------------
void DestroyListener(struct LISTENER * L)
{
        free(L->name);
        free(L->address);
        free(L->port);
        free(L);
}
//----------------------------------------------
int AddListener(PVSESSION VSession, struct LISTENER * Listener)
{
        //printf("\n AddListener : [1] ");
        int status;
        if (VSession->Session.IsActive())
        {       status = VSession->Session.AddDestination(Listener->iaddress,Listener->iport);
                if (status < 0)
                {       //VSession->Session.Destroy();
                        printf("\n AddListener : [error] %s  ",JVOIPGetErrorString(status).c_str());
                        return 0; //NULL ;
                }
                if(print_out) printf("\n AddListener : Destination Added Successfully ");
                return 1;
        }
        if(print_out) printf(" \n AddListener : You do not have an active Session ");
        return 0;
}
//----------------------------------------------
int DropListener(PVSESSION VSession, struct LISTENER * Listener)
{
        //printf("\n DropListener : [1] ");
        int status;
        if (VSession->Session.IsActive())
        {       status = VSession->Session.DeleteDestination(Listener->iaddress,Listener->iport);
                if (status < 0)
                {       //VSession->Session.Destroy();
                        printf("\n DropListener : [error] %s ",JVOIPGetErrorString(status).c_str());
                        return 0;
                }
                //if(print_out) printf("\n DropListener : Destination Deleted Successfully ");
                return 1;
        }
        if(print_out) printf(" \n DropListener : You do not have an active Session  ");
        return 0;
}
//----------------------------------------------
void Cast(PVSESSION VSession, char *Destinations)
{
        //printf("\n Cast : [1] ");

        char *dest=NULL;
        struct LISTENER * Listener=NULL;
        int i=0,k=0;

        if (Destinations != NULL){
                dest = (char*) malloc(60);
                for(i=0; i<=strlen(Destinations);++i,++k){
                        if ((Destinations[i] == ',')||(Destinations[i] == ';')||(Destinations[i] == '|')||(Destinations[i] == '\0')){
                                dest[k] = '\0';
                                Listener = GetListenerInfo(dest);
                                AddToList(VSession,dest);
                                AddListener(VSession,Listener);
                                printf("\n--------------------------[Cast]\n");
                                DestroyListener(Listener);
                                //free(Listener);
                                dest = (char*) malloc(60); // allocate the next dest
                                k=-1;
                        }
                        else{
                                dest[k] = Destinations[i];
                        }
                }
                free(dest); // free the extra dest when Destinations[i]=='\0'
        }
        else
                if(print_out) printf("\n Cast : Destinations are Empty ?!?!");
}
//----------------------------------------------
void DropCast(PVSESSION VSession, char *Destinations)
{
        //printf("\n\n\n DropCast : [1] : ===============------Destinations=[%s]",Destinations);
        char *destination; /*[60];*/
        struct LISTENER * Listener=NULL;
        int pos;
        int i=0,k=0;

        destination = (char*) malloc(60 * sizeof(char));
        for(i=0; i<=strlen(Destinations);++i,++k){
                if ((Destinations[i] == ',')||(Destinations[i] == ';')||(Destinations[i] == '|')||(Destinations[i] == '\0')){
                        destination[k] ='\0';
                        pos = IsInVList(VSession,destination);
                        if(pos > -1){
                                //printf("\n DropCast : Listener is [%s] at pos[%d]",VSession->ListenerList[pos],pos);
                                Listener = GetListenerInfo(VSession->ListenerList[pos]);
                                DeleteFromList(VSession, pos);
                                DropListener(VSession,Listener);
                                //printf("\n-----------------[DropCast]------[Ok]\n");
                                DestroyListener(Listener);
                                /*free(Listener);*/
                        }else
                                printf("\n DropCast : Listener is not Found\n");
                        k=-1;
                }
                else{
                        destination[k] = Destinations[i];
                }
        }
        free(destination);
        //printf("\n DropCast : =================--------------End\n");
}

//----------------------------------------------
#define VAdd            1
#define VDrop           2
#define VWho            3
//----------------------------------------------
int GetCommand(char Command[])
{
        char *sp=NULL;
        if((sp = strstr(Command,"+=")) != NULL) return VAdd;
        if((sp = strstr(Command,"-=")) != NULL) return VDrop;
        return VWho;
}
//----------------------------------------------
char * GetDestinations(char Command[])
{
        char *dest=NULL;
        int i=0;
        char *sp=NULL;

        sp = strchr(Command,'=');
        if(sp != NULL){
                sp++;
                dest = (char*) malloc(300);
                while(*sp != '\0'){
                        dest[i]=*sp;
                        ++sp;
                        ++i;
                }
                dest[i]='\0';
                return dest;
        }
        return NULL;
}
//----------------------------------------------
void SetVoiceAttrib(PVSESSION VSession, char StrAttrib[])
{
        //printf("\n SetVoiceAttrib : [1] ");

        int CmdCode;
        char *destlist=NULL;
        if (VSession->Session.IsActive()){
                if( (CmdCode = GetCommand(StrAttrib))){
                        switch(CmdCode) {
                                case VAdd:      if( (destlist = GetDestinations(StrAttrib)) != NULL){
                                                        Cast(VSession,destlist);
                                                        free(destlist);
                                                }
                                                break;

                                case VDrop:     if( (destlist = GetDestinations(StrAttrib)) != NULL){
                                                        DropCast(VSession,destlist);
                                                        free(destlist);
                                                }
                                                break;

                                case VWho:      PrintWhoInVList(VSession);
                                                break;
                        }
                }
                else
                        printf("\n SetVoiceAttrib : you must have an Accurate Attribute ");
        }
        else
                printf("\n SetVoiceAttrib : you must have an active session ");
}
//----------------------------------------------
int InitVoiceSession(PVSESSION VSession, char SessionPort[5])
{
        InitList(VSession);

        int destport;
        sscanf( SessionPort ,"%d",&destport);
        int status;

        if (VSession->Session.IsActive())
        {
                if(print_out) printf(" \n InitVoiceSession : Session already active ");
                return 0;
        }

        VSession->rtpparams.SetAcceptOwnPackets(true);
        destport=0;
        sscanf(SessionPort,"%d",&destport);
        if(print_out) printf("\n InitVoiceSession : seting up the port [%d] ",destport);
        VSession->rtpparams.SetPortBase(destport);

        VSession->sessparams.SetTransmissionParams(&(VSession->rtpparams));

        //---------------------------
        #ifndef WIN32
                VSession->sndinparams.SetMultiplyFactor(1);
                VSession->sessparams.SetVoiceInputParams(&(VSession->sndinparams));

                VSession->sndoutparams.SetMultiplyFactor(1);
                VSession->sessparams.SetVoiceOutputParams(&(VSession->sndoutparams));
        #endif
        //---------------------------

        status = VSession->Session.Create(VSession->sessparams);
        if (status < 0)
        {
                if(print_out) printf("\n InitVoiceSession : status = %d ", status);
                printf("\n InitVoiceSession : error  = %s ",JVOIPGetErrorString(status).c_str());
                return status;
        }
        printf("\n InitVoiceSession : Voice Session Initialized Successfully at Port = [%d] \n",destport);
        return 1;
}
//----------------------------------------------
PVSESSION CreateVoiceSession(char SessionPort[5] , char Destinations[] )
{
        int status;
        char *dest=NULL;
        PVSESSION VSession;
        VSession = new VSESSION;

        //dest=(char*) malloc(sizeof(Destinations));

        #ifdef WIN32
                        StartupWinSocket();
        #endif
        status =  InitVoiceSession(VSession, SessionPort);
        if( status < 0 ){
                if(print_out) printf("\n CreateVoiceSession : Can not initialize the VSession ");
                return NULL;
        }

        if((Destinations != NULL) && (strcmp(Destinations,"") != 0)){
                dest = strdup(Destinations);
                //strcpy(dest,Destinations);
                printf("\n CreateVoiceSession : dest=[%s]",dest);
                Cast(VSession,dest);
        }
        free(dest);
        return VSession;
}
//----------------------------------------------
void CloseVoiceSession(PVSESSION VSession)
{
        VSession->Session.Destroy();
        DestroyList(VSession);

        #ifdef WIN32
                        CleanupWinSocket();
        #endif
        delete VSession;
        printf("\n CloseVoiceSession : Session Closed Successfully\n ");
}
//----------------------------------------------
