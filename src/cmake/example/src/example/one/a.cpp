#include <example/one/a.h>

#include <cstdlib>
#include <cstring>

namespace example { namespace one {

void a::load(std::vector<std::string>* result)
{
	result->push_back("example::one::a");
}

} } // close namespace 'example::one'

