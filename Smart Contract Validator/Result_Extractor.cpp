//#include<bits/stdc++.h>
#include<fstream>
#include<iostream>
#include<cstring>
#include<string>

using namespace std;


int main(int argc,char* args[])
{
    ifstream fin;
    ofstream fout;
    string SourceFile=strcat(args[1],"");
    string DestinationFile=strcat(args[2],"");
    string type=strcat(args[3], "");
    string StartingString1="Warning: BMC: Assertion violation happens here.";
    string StartingString2="Warning: CHC: Assertion violation happens here.";
    string StartingString3 = "Warning: CHC: Assertion violation might happen here.";
    string ClosingString="Note: Callstack:";
    
    fin.open(SourceFile);
    fout.open(DestinationFile);
    string outputPerLine;


    if(type == "BMC"){
        while(getline(fin,outputPerLine)){
            if(outputPerLine==StartingString1)
            {
                while(outputPerLine!=ClosingString)
                {
                    fout<<outputPerLine<<endl;
                    if(!getline(fin,outputPerLine)) break;
                }
            }
        }
    }
    else{
        while(getline(fin, outputPerLine) && outputPerLine != StartingString2 && outputPerLine != StartingString3){
            //cout<<"in loop"<<endl;
        }

        while(getline(fin, outputPerLine)){
            //cout<<"out of lop"<<endl;
            fout<<outputPerLine<<endl;
        }
    }
    return 0 ;
}
