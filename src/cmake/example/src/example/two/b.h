#ifndef EXAMPLE_TWO_B_INCLUDED
#define EXAMPLE_TWO_B_INCLUDED

#include <string>
#include <vector>

namespace example { namespace two {

// Provides mechanism type 'b' in the 'two' example namespace.
class GDE_EXPORT b
{
public:
	// Load into the specified 'result' the strings defined by this mechanism.
	static void load(std::vector<std::string>* result);
};

} } // close namespace 'example::two'

#endif
