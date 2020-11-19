#include <example/two/b.h>

#include <cstdlib>
#include <cstring>

namespace example { namespace two {

void b::load(std::vector<std::string>* result)
{
	result->push_back("example::two::b");
}

} } // close namespace 'example::two'

