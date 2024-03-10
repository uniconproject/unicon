
struct VOIPSession;
typedef struct VOIPSession VSESSION;
typedef struct VOIPSession* PVSESSION;

#ifdef WIN32
        int StartupWinSocket(void);
        int CleanupWinSocket(void);
#endif

char * FetchListener(PVSESSION VSession, int pos);
char * FetchName(PVSESSION VSession, int pos);
char * FetchAddress(PVSESSION VSession, int pos);
int GetVListSize(PVSESSION VSession);

PVSESSION CreateVoiceSession(char SessionPort[5] , char Destinations[] );
void SetVoiceAttrib(PVSESSION VSession, char StrAttrib[]);
void CloseVoiceSession(PVSESSION VSession);


