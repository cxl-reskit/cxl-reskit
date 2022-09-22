project(
    'cxl-reskit',
    'c',
    version: files('VERSION'),
    license: 'Apache-2.0',
    default_options: [
        'prefix=/opt/cxl-reskit',
        'buildtype=debugoptimized',
    ],
    meson_version: '>=0.57.0'
)

if get_option('benchmarks')
    subdir('benchmarks')

    find_program('mlc')
    find_program('multichase')
    find_program('multiload')
    find_program('fairness')
    find_program('pingpong')
    find_program('stream')
endif

ndctl_default_options = [
    'default_library=static',
    'werror=false',
    'warning_level=0',
    'asciidoctor=disabled',
    'docs=disabled',
    'poison=disabled',
    'rootprefix=' + get_option('prefix'),
    'test=disabled',
]
dependency('libcxl', fallback: 'ndctl', default_options: ndctl_default_options)
dependency('libdaxctl', fallback: 'ndctl', default_options: ndctl_default_options)
dependency('libndctl', fallback: 'ndctl', default_options: ndctl_default_options)
find_program('cxl')
