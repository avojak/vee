# Project name and programming language
project('com.github.avojak.vee', 'vala', 'c', version: '1.0.0')

i18n = import('i18n')
gnome = import('gnome')

vala_args = ['--pkg', 'posix']

application_id = meson.project_name()
application_name = 'Vee'

# Set our translation domain
add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()), language: 'c')

# Set out log domain
add_project_arguments('-DG_LOG_DOMAIN="@0@"'.format(meson.project_name()), language: 'c')

add_project_arguments(
    ['--vapidir', join_paths(meson.current_source_dir(), 'vapi')],
    language: 'vala'
)

subdir('data')
subdir('src')
# subdir('test')
subdir('po')

meson.add_install_script('meson/post_install.py')
