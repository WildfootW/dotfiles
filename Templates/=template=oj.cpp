/*
 * %FFILE%
 * Copyleft (ɔ) %YEAR% %USER% <%MAIL%>
 *
 * Distributed under terms of the %LICENSE% license.
 */

// [ ] Completed

#include <iostream>
#include <ctime>

#define INF 2147483647
#define EPS 1e-9
#define DEFAULT_FIXSTR 3

using namespace std;

inline string _fixstr(string para, int alignment_num = DEFAULT_FIXSTR)
{
    para.resize(alignment_num, ' ');
    return para;
}
inline string _fixstr(char para, int alignment_num = DEFAULT_FIXSTR)
{
    string ret = string(1, para);
    return _fixstr(ret, alignment_num);
}
inline string _fixstr(int para, int alignment_num = DEFAULT_FIXSTR)
{
    string ret = to_string(para);
    if(para == INF)
        ret = "INF";
    return _fixstr(ret, alignment_num);
}

%HERE%

int main()
{
    ios::sync_with_stdio(false);
    cin.tie(0);

    clog << "Time used = " << (double)clock() / CLOCKS_PER_SEC << endl;
    return 0;
}
