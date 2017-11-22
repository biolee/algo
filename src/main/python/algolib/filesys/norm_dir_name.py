import os

algo_path = os.environ.get("REPO_PATH_ALGO")
assert algo_path.endswith("algo")

if __name__ == '__main__':

    for root,dirs,files in os.walk(algo_path + "/src/main/java/"):
        if "uva" in root.lower():
            print(root,dirs,files)

        for file in files:
            if file.endswith(".java") or file.endswith(".scala"):
                continue

