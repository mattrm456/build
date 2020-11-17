#include <example/one/b.h>

int main(int argc, const char** argv)
{
    std::vector<std::string> result;
    example::one::b::load(&result);
    
    if (result.size() == 1 && result[0] == "example::one::b")
    {
        return 0;
    }
    
    return 1;
}

