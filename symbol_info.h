#include <bits/stdc++.h>

using namespace std;

class symbol_info
{
private:
    string sym_name;
    string sym_type;

public:
    string result;
    symbol_info(string name, string type)
    {
        sym_name = name;
        sym_type = type;
        result = name;
    }

    string getname() const
    {
        return sym_name;
    }

    string gettype() const
    {
        return sym_type;
    }
};
