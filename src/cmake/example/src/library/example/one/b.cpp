#include <example/one/b.h>

#include <cstdlib>
#include <cstring>

namespace example { namespace one {

void b::load(std::vector<std::string>* result)
{
	result->push_back("example::one::b");
}

} } // close namespace 'example::one'

