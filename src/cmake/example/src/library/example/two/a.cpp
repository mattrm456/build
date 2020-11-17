#include <example/two/a.h>

#include <cstdlib>
#include <cstring>

namespace example { namespace two {

void a::load(std::vector<std::string>* result)
{
	result->push_back("example::two::a");
}

} } // close namespace 'example::two'

