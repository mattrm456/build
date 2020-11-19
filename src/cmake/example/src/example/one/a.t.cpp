#include <example/one/a.h>

int main(int argc, const char** argv)
{
    std::vector<std::string> result;
    example::one::a::load(&result);
    
    if (result.size() == 1 && result[0] == "example::one::a")
    {
        return 0;
    }
    
    return 1;
}

