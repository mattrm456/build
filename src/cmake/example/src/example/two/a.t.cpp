#include <example/two/a.h>

int main(int argc, const char** argv)
{
    std::vector<std::string> result;
    example::two::a::load(&result);
    
    if (result.size() == 1 && result[0] == "example::two::a")
    {
        return 0;
    }
    
    return 1;
}

