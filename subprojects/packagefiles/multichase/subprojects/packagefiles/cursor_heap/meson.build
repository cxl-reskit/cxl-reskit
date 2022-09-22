project(
    'cursor_heap',
    'c',
    meson_version: '>=0.54.0'
)

cursorheap = library(
    'cursorheap',
    'cursor_heap.c',
    'cheap_dax.c'
)

cursorheap_dep = declare_dependency(
    link_with: cursorheap,
    include_directories: include_directories('.')
)

if get_option('tests')
    subdir('testlib')
    subdir('test')
endif

meson.override_dependency('cursorheap', cursorheap_dep)
