add_languages('cpp', native: false)

gtest_dep = dependency(
    'gtest',
    main: true,
    fallback: ['gtest', 'gtest_main_dep'],
    default_options: [
        'default_library=static',
        'warning_level=0',
        'werror=false',
    ]
)

cheap_test = executable(
    'cheap_test',
    'cheap_test.cpp',
    dependencies: [
        cursorheap_dep,
        cheaptest_dep,
        gtest_dep,
    ]
)

test('cheap_test', cheap_test)
