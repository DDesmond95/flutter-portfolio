# Deploying to GitHub Pages

This guide explains how to deploy your Flutter Portfolio to GitHub Pages.

## Prerequisites

1.  A GitHub repository.
2.  Flutter installed.

## Step 1: Build for Web

You must specify the `--base-href` which corresponds to your repository name.

- **If your repo is `username.github.io` (User Site)**:

  ```bash
  flutter build web --release --base-href "/"
  ```

- **If your repo is `my-portfolio` (Project Site)**:
  ```bash
  flutter build web --release --base-href "/my-portfolio/"
  ```

## Step 2: Deploy to `gh-pages` branch

We will use the `gh-pages` branch to host the static files.

1.  Go to the build directory:

    ```bash
    cd build/web
    ```

2.  Initialize git (if not already):

    ```bash
    git init
    git add .
    git commit -m "Deploy Update"
    ```

3.  Push to `gh-pages` branch (force push to overwrite):
    ```bash
    # Replace with your repo URL
    git remote add origin https://github.com/StartInfininite/my-portfolio.git
    git push -f origin master:gh-pages
    ```

## Notes

- **404.html**: We have added a `404.html` file that helps GitHub Pages handle Flutter's routing. This ensures that refreshing a page like `/blog` works correctly.
- **Encryption**: Your content is encrypted using hardware-accelerated WebCrypto API. It is safe to commit the `assets/contents` folder.
