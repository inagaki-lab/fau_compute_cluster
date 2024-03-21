import pkg_resources

def list_installed_modules():
    'List all installed modules in the current Python environment'
    installed_packages = pkg_resources.working_set
    installed_packages_list = sorted(["%s==%s" % (i.key, i.version)
       for i in installed_packages])
    for m in installed_packages_list:
        print(m)

list_installed_modules()