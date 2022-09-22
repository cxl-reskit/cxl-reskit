project(
    'multichase',
    'c',
    license: 'Apache-2.0',
    default_options: [
        'warning_level=1',
    ],
    meson_version: '>=0.55.0'
)

cc = meson.get_compiler('c')

threads_dep = dependency('threads')
m_dep = cc.find_library('m')
rt_dep = cc.find_library('rt')
cursorheap_dep = dependency(
    'cursorheap',
    default_options: [
        'default_library=static',
        'warning_level=0',
        'werror=false',
    ]
)

add_project_arguments(cc.get_supported_arguments(
        '-fomit-frame-pointer',
        '-fno-unroll-loops',
        '-Wstrict-prototypes',
        '-Wmissing-prototypes',
        '-Wnested-externs',
        '-Wpointer-arith',
        '-Wno-unused-parameter',
        '-Wno-tautological-compare'
    ),
    language: 'c'
)

expand_h = custom_target(
    'expand.h',
    capture: true,
    output: 'expand.h',
    command: [
        'gen_expand',
        '200'
    ]
)

multichase = executable(
    'multichase',
    'multichase.c',
    'permutation.c',
    'arena.c',
    'util.c',
    expand_h,
    dependencies: [cursorheap_dep]
)

multiload = executable(
    'multiload',
    'multiload.c',
    'permutation.c',
    'arena.c',
    'util.c',
    expand_h,
    dependencies: [
        cursorheap_dep,
        m_dep,
    ]
)

fairness = executable(
    'fairness',
    'fairness.c',
    expand_h,
    dependencies: [m_dep]
)

pingpong = executable(
    'pingpong',
    'pingpong.c'
)

meson.override_find_program('multichase', multichase)
meson.override_find_program('multiload', multiload)
meson.override_find_program('fairness', fairness)
meson.override_find_program('pingpong', pingpong)
