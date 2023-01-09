//#include<bits/stdc++.h>

#include<fstream>
#include<iostream>
#include<cstring>
using namespace std;
int main(int argc, char * args[]){
    ifstream fin;
    ofstream fout;

    string InputFile = strcat(args[1],"");
    string OutputFile;
    string InterMediateFile;

    InterMediateFile=InputFile+"_Intermediate.sol";
    OutputFile=InputFile+"_Sanitized.sol";
    InputFile=InputFile+".sol";
    
    
    fin.open(InputFile);
    fout.open(InterMediateFile);

    string SentencePerLine;

    while(getline(fin,SentencePerLine)){
        int pos=0;
        string TempLine="";
        bool CommentFound=false;
        while(SentencePerLine[pos]!='\0')
        {
            if(SentencePerLine[pos]=='/' && SentencePerLine[pos+1]=='/')
            {
                if(pos==0)
                {
                    CommentFound=true;
                    break;
                }
                else
                {
                    for(int i=0;i<pos;i++)
                    {
                        TempLine=TempLine+SentencePerLine[i];
                    }
                    fout<<TempLine<<endl;
                    CommentFound=true;
                    break;
                }
            }
            else if(SentencePerLine[pos]=='/' && SentencePerLine[pos+1]=='*')
            {
                while(SentencePerLine[pos]!='*' || SentencePerLine[pos+1]!='/')
                {
                    if(SentencePerLine[pos]=='\0')
                    {
                        getline(fin,SentencePerLine);
                        pos=0;
                    }
                    else
                    {
                        pos++;
                    }
                }
                CommentFound=true;
                break;
            }
                pos++;
        }
        if(!CommentFound)
        {
            fout<<SentencePerLine<<endl;
        }
    }
    fin.close();
    fout.close();
    fin.open(InterMediateFile);
    fout.open(OutputFile);

    string codePerLine="";
    while(getline(fin,codePerLine))
    {
        int pos=0;
        while(codePerLine[pos]==' '||codePerLine[pos]=='\t')
        {
            pos++;
        }
         if(codePerLine[pos]=='\0')
         {
           continue;
         }
         else
         {
             fout<<codePerLine<<endl;
         }
    }
    fin.close();
    fout.close();
    return 0;
}