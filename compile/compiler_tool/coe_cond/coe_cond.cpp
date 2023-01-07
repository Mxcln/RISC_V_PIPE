#include<iostream>
#include<istream>
#include<ostream>
#include<fstream>
#include<string>
#include<vector>

// function convh_b 
std::string convh_b(char one_h_digit)
{
    std::string four_b_digit;
    switch(one_h_digit)
    {
        case '0': four_b_digit = "0000"; break;
        case '1' :four_b_digit = "0001"; break;
        case '2': four_b_digit = "0010"; break;
        case '3': four_b_digit = "0011"; break;
        case '4': four_b_digit = "0100"; break;
        case '5': four_b_digit = "0101"; break;
        case '6': four_b_digit = "0110"; break;
        case '7': four_b_digit = "0111"; break;
        case '8': four_b_digit = "1000"; break;
        case '9': four_b_digit = "1001"; break;
        case 'A': four_b_digit = "1010"; break;
        case 'B': four_b_digit = "1011"; break;
        case 'C': four_b_digit = "1100"; break;
        case 'D': four_b_digit = "1101"; break;
        case 'E': four_b_digit = "1110"; break;
        case 'F': four_b_digit = "1111"; break;
    }
    return four_b_digit;
}
std::string conv_2h_b(std::string h_string)
{
    return convh_b(h_string[0]) + convh_b(h_string[1]);
}

int main(void)
{
    std::string fname;
    std::string zero;
    std::ofstream write;
    std::ifstream read;

    std::vector<std::string> inst_to_reverse;
    
    std::string temp;

    std::cin >> fname;                          //读取文件的名称

    //打开文件
    write.open(fname+".coe", std::ios::out);
    if(!write)
        exit(-1);
    read.open(fname+".data",std::ios::in);
    if(!read)
        exit(-1);

    std::getline(read,zero);                    //跳过第一行

    write << "memory_initialization_radix = 2;\nmemory_initialization_vector =\n";
    
    while(read.rdbuf()->in_avail()!=0)
    {
        read  >> temp;
        inst_to_reverse.push_back(temp);
    }

    int i=0;
    while(inst_to_reverse.size() >= i*4+4)
    {
        for(int j=i*4+3;j>=i*4;j--) {
            write << conv_2h_b(inst_to_reverse.at(j));
            if(j==i*4&&inst_to_reverse.size() <= i*4+8)
                write   << ";";
            else if(j==i*4)
                write << ",\n";
        }
        i++;
    }

    read.close();
    write.close();
    return 0;
}