try:
    import concurrent.futures as futures
except ImportError:
    try:
        import futures
    except ImportError:
        futures = None

import zipfile
import shutil
import tempfile
import requests
import sys

from os import path

# --- Globals ----------------------------------------------
PLUGINS = """
vim-go https://github.com/fatih/vim-go
""".strip()

GITHUB_ZIP = "%s/archive/master.zip"

SOURCE_DIR = path.join(path.dirname(__file__), "my_plugins")


def download_extract_replace(plugin_name, zip_path, temp_dir, source_dir):
    temp_zip_path = path.join(temp_dir, plugin_name)

    # Download and extract file in temp dir
    req = requests.get(zip_path)
    open(temp_zip_path, "wb").write(req.content)

    zip_f = zipfile.ZipFile(temp_zip_path)
    zip_f.extractall(temp_dir)

    plugin_temp_path = path.join(
        temp_dir, path.join(temp_dir, "%s-master" % plugin_name)
    )

    # Remove the current plugin and replace it with the extracted
    plugin_dest_path = path.join(source_dir, plugin_name)

    try:
        shutil.rmtree(plugin_dest_path)
    except OSError:
        pass

    shutil.move(plugin_temp_path, plugin_dest_path)
    print("Updated {0}".format(plugin_name))


def update(plugin):
    name, github_url = plugin.split(" ")
    zip_path = GITHUB_ZIP % github_url
    download_extract_replace(name, zip_path, temp_directory, SOURCE_DIR)


if __name__ == "__main__":
    doc = """usage: python3 %s [-h|--help] [--all] [--list] [plugin]...

-h --help   print this help doc
--all       update all plugins
--list      list supported plugins
[plugin]    update the plugin specified by multi [plugin]
    """ % sys.argv[0]
    if len(sys.argv) == 1 or sys.argv[1] == "-h" or sys.argv[1] == "--help":
        print (doc)
        sys.exit(0)

    plugins = PLUGINS.splitlines()
    if sys.argv[1] == "--list":
            for plugin in plugins:
                print (plugin)
            sys.exit(0)

    temp_directory = tempfile.mkdtemp()

    try:

        if sys.argv[1] == "--all":
            if futures:
                with futures.ThreadPoolExecutor(16) as executor:
                    executor.map(update, plugins)
            else:
                [update(x) for x in plugins]
        else:
            plugin_dict = {}
            for plugin in plugins:
                name, _ = plugin.split(" ")
                plugin_dict[name] = plugin

            for x in sys.argv[1:]:
                if x in plugin_dict:
                    update(plugin_dict[x])

    finally:
        shutil.rmtree(temp_directory)
