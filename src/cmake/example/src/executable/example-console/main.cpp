#include <example-console/version.h>

#include <example/two/a.h>
#include <example/two/a.h>

#include <example/one/a.h>
#include <example/one/b.h>

#include <iostream>
#include <cstdlib>
#include <cstring>

int main(int argc, const char** argv)
{
    std::vector<std::string> result;
    
    example::one::a::load(&result);
    example::one::b::load(&result);
    
    example::two::a::load(&result);
    example::two::b::load(&result);
    
    for (std::vector<std::string>::const_iterator it  = result.begin(); 
                                                  it != result.end(); 
                                                ++it)
    {
        std::cout << *it << std::endl;
    }
    
    return 0;
}