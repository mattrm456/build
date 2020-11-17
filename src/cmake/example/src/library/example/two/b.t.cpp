#include <example/two/b.h>

int main(int argc, const char** argv)
{
    std::vector<std::string> result;
    example::two::b::load(&result);
    
    if (result.size() == 1 && result[0] == "example::two::b")
    {
        return 0;
    }
    
    return 1;
}

