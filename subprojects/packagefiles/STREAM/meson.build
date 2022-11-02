project(
    'STREAM',
    'c',
    meson_version: '>=0.46.0'
)

stream = executable(
    'stream',
    'stream.c',
    c_args: [
        '-fopenmp',
    ],
    link_args: [
        '-fopenmp',
    ]
)

meson.override_find_program('stream', stream)
