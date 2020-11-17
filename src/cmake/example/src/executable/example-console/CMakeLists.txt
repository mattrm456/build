add_executable(
    example-console
    main.cpp
    version.cpp
)

target_link_libraries(
    example-console
    PUBLIC
    example
    # infrastructure::infrastructure
)

install(
    TARGETS
        example-console
    EXPORT
        ${CMAKE_PROJECT_NAME}-targets
    RUNTIME DESTINATION
        bin
)

