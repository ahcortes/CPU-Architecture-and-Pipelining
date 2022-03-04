#include <iostream>
#include <algorithm> 
#include <bitset>  

using namespace std;

#define MEMORY_SIZE 256
#define PADDING_INDEX 61
#define LFSR_TAP_INDEX 62
#define LFSR_SEED_INDEX 63
#define ENCRYPTION_INDEX 64

#define MESSAGE_SIZE 52
#define PADDING_SIZE 15
#define PADDING_CHAR ' '
                  
#define TAPS0 0b1100000
#define TAPS1 0b1001000
#define TAPS2 0b1111000
#define TAPS3 0b1110010
#define TAPS4 0b1101010
#define TAPS5 0b1101001
#define TAPS6 0b1011100
#define TAPS7 0b1111110
#define TAPS8 0b1111011

#define LFSR_SIZE 7
#define LFSR_SEED 0b0100000

#define ERROR_FLAG 0x80

// Global Memory
char memory[MEMORY_SIZE]={
        'M','r','.',' ','W','a','t','s','o',
        'n',',',' ','c','o','m','e',' ','h','e',
        'r','e','.',' ','I',' ','w','a','n','t',
        ' ','t','o',' ','s','e','e',' ','y','o',
        'u','.'
};

void nextLFSR(bitset<LFSR_SIZE> &lfsr, bitset<LFSR_SIZE> &taps){
    // LFSR={LFSR[5:0],^(LFSR&Taps)}    
    bitset<LFSR_SIZE> newbit = (lfsr&taps).count()%2;
    lfsr = (lfsr<<1)|newbit;
}

void encryptMessage(){
    cout<<endl<<"ENCRYPTING..."<<endl; 
    // Initialize LFSR and Taps
    bitset<LFSR_SIZE> taps(memory[LFSR_TAP_INDEX]);
    bitset<LFSR_SIZE> lfsr(memory[LFSR_SEED_INDEX]);
    cout<<"Taps:"<<taps<<endl;
    cout<<"Seed:"<<lfsr<<endl;
    
    // Calculate Message Length
    cout<<"Message:"; 
    int mSize = 0;
    while(memory[mSize] || memory[mSize]!='\0'){
        cout<<memory[mSize++];
    }
    cout<<endl<<"Message Length:"<<mSize<<endl;
    
    // Caluculate and Store Padding Size
    memory[PADDING_INDEX] = PADDING_SIZE;
    cout<<"Padding Length:"<<int(memory[PADDING_INDEX])<<endl;
    
    // Encrypt Padding
    cout<<endl<<"Encrypting Padding:"<<endl;
    bitset<LFSR_SIZE> sBits(PADDING_CHAR);    
    int wOffset = ENCRYPTION_INDEX; 
    for(int i=0; i<PADDING_SIZE; i++){
        // Encrypt Char
        bitset<LFSR_SIZE> eBits = sBits^lfsr;
        memory[wOffset+i] = eBits.to_ulong()+(eBits.count()%2<<7);
        cout<<"' '("<<sBits<<")^lfsr["<<lfsr.to_ulong()<<"]("<<lfsr<<")->";
        cout<<"'"<<memory[wOffset+i]<<"'["<<int(memory[wOffset+i])<<"]("<<bitset<LFSR_SIZE+1>(memory[wOffset+i])<<")"<<endl;
        nextLFSR(lfsr,taps);
    }

    // Encrypt Message
    cout<<endl<<"Encrypting Message:"<<endl;
    wOffset = ENCRYPTION_INDEX+PADDING_SIZE; 
    for(int i=0; i<mSize; i++){
        // Encrypt Char
        sBits = bitset<LFSR_SIZE>(memory[i]);    
        bitset<LFSR_SIZE> eBits = sBits^lfsr;
        memory[wOffset+i] = eBits.to_ulong()+(eBits.count()%2<<7);
        cout<<"'"<<memory[i]<<"'("<<sBits<<")^lfsr("<<lfsr<<")->";
        cout<<"'"<<memory[wOffset+i]<<"'["<<int(memory[wOffset+i])<<"]("<<bitset<LFSR_SIZE+1>(memory[wOffset+i])<<")"<<endl;
        nextLFSR(lfsr,taps);
    }
    cout<<"ENCRYPTION DONE"<<endl;
}

void findTaps(bitset<LFSR_SIZE> &lfsr, bitset<LFSR_SIZE> &taps){
    bitset<LFSR_SIZE> allTaps[9]={
        TAPS0,TAPS1,TAPS2,TAPS3,TAPS4,TAPS5,TAPS6,TAPS7,TAPS8
    };
    int tLength = sizeof(allTaps)/sizeof(allTaps[0]);
    
    // Calculate Seed
    bitset<LFSR_SIZE> pBits(PADDING_CHAR);
    bitset<LFSR_SIZE> eBits(memory[ENCRYPTION_INDEX]);
    bitset<LFSR_SIZE> seed = eBits^pBits;
    cout<<"seed:"<<seed<<endl;
    
    // Test All Taps
    for(int i=0; i<tLength; i++){
        cout<<"Checking Taps["<<i<<"]("<<allTaps[i]<<"):"<<endl;   
        lfsr = seed;

        // Compare Padding Encryption Sequence
        int j;
        for(j=0; j<PADDING_SIZE; j++){
            bitset<LFSR_SIZE> tBits = pBits^lfsr;
            eBits = bitset<LFSR_SIZE>(memory[ENCRYPTION_INDEX+j]);
            cout<<"'"<<PADDING_CHAR<<"'["<<int(PADDING_CHAR)<<"]("<<pBits<<")^";
            cout<<"lfsr["<<lfsr.to_ulong()<<"]("<<lfsr<<") -> ";
            cout<<"'"<<char(tBits.to_ulong())<<"'["<<tBits.to_ulong()<<"]("<<tBits<<") vs ";
            cout<<"'"<<char(eBits.to_ulong())<<"'["<<eBits.to_ulong()<<"]("<<eBits<<") ";
            if(tBits != eBits){
                cout<<"Failed"<<endl<<endl;
                break;
            }
            cout<<"Passed"<<endl;
            nextLFSR(lfsr,allTaps[i]);
        }

        // Store Successful Taps
        if(j == PADDING_SIZE){
            taps = allTaps[i];
            cout<<"Passed!"<<endl;
            break;
        }
    }

    lfsr = seed;
}

void decryptMessage(){
    cout<<endl<<endl<<"DECRYPTING..."<<endl;
    
    // Get Decryption Taps
    bitset<LFSR_SIZE> lfsr;
    bitset<LFSR_SIZE> taps;
    findTaps(lfsr, taps);
    
    // Decrypt Message
    cout<<endl<<"Decrypt And Store"<<endl;
    for(int i=0; i<=MESSAGE_SIZE; i++){
        bitset<LFSR_SIZE> eBits(memory[ENCRYPTION_INDEX+i]);    
        memory[i] = (eBits^lfsr).to_ulong();
        cout<<"'"<<memory[ENCRYPTION_INDEX+i]<<"'["<<int(memory[ENCRYPTION_INDEX+i])<<"]("<<eBits<<")^";
        cout<<"lfsr["<<lfsr.to_ulong()<<"]("<<lfsr<<")->";
        cout<<"'"<<memory[i]<<"'["<<int(memory[i])<<"]("<<bitset<LFSR_SIZE>(memory[i])<<")"<<endl;
        nextLFSR(lfsr,taps);
    }
    cout<<"DECRYPTION DONE"<<endl;
}

void decryptMessageUpgraded(){
    cout<<endl<<endl<<"UPGRADED DECRYPTION..."<<endl;
    
    // Get Decryption Taps
    bitset<LFSR_SIZE> lfsr;
    bitset<LFSR_SIZE> taps;
    findTaps(lfsr, taps);
    
    // Skip Padding
    cout<<endl<<"Skiping All Padding"<<endl;
    int pOffset;
    for(pOffset=0; pOffset<PADDING_SIZE; pOffset++){
        bitset<LFSR_SIZE> eBits(memory[ENCRYPTION_INDEX+pOffset]);
        if((eBits^lfsr).to_ulong() != PADDING_CHAR){
            break;
        }
        nextLFSR(lfsr,taps);
    }
    cout<<"Padding Offset:"<<pOffset<<endl;
    
    // Decrypt Message
    cout<<endl<<"Decrypt And Store"<<endl;
    int mSize = MESSAGE_SIZE-pOffset;
    for(int i=0; i<=mSize; i++){
        // Dycrypt Char
        bitset<LFSR_SIZE> eBits(memory[ENCRYPTION_INDEX+pOffset+i]);    
        bitset<LFSR_SIZE> sBits = eBits^lfsr;
            
        // Error Check
        bool parity = memory[ENCRYPTION_INDEX+pOffset+i]>>7;
        memory[i] =(parity!=(eBits.count()%2))? 
            ERROR_FLAG: 
            sBits.to_ulong();

        // Continue
        cout<<"'"<<memory[ENCRYPTION_INDEX+pOffset+i]<<"'["<<int(memory[ENCRYPTION_INDEX+pOffset+i])<<"]("<<parity<<eBits<<")^";
        cout<<"lfsr["<<lfsr.to_ulong()<<"]("<<lfsr<<")->";
        cout<<"'"<<memory[i]<<"'["<<int(memory[i])<<"]("<<bitset<LFSR_SIZE>(memory[i])<<")"<<endl;        
        nextLFSR(lfsr,taps);
    }

    cout<<"UPGRADED DECRYPTION DONE"<<endl;
}

int main(){
    // Initialize Memory (TestBench)
    memory[LFSR_TAP_INDEX] = char(TAPS1);
    memory[LFSR_SEED_INDEX] = char(LFSR_SEED);

    // Program 1
    encryptMessage();
    
    // Program 2
    decryptMessage();

    // Program 3
    decryptMessageUpgraded();
}