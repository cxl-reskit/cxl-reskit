cheaptest = static_library(
    'cheaptest',
    'cheap_testlib.c',
    'random_buffer.c',
    'xrand.c',
    dependencies: [cursorheap_dep]
)

cheaptest_dep = declare_dependency(
    link_with: cheaptest,
    include_directories: include_directories('.')
)
