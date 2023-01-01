name: Python-debug
on:
  push:
    branches: [ "main" ]
  #pull_request:
  #  branches: [ "main" ]
  schedule:
    # * is a special character in YAML so you have to quote this string
    - cron:  '0 17 * * *'

jobs:
  job_update:
    name: Python Crawler
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v2
    - name: '指定python环境'
      uses: actions/setup-python@v3
      with:
        python-version: "3.7"
    - name: "安装运行环境1"
      run: pip install beautifulsoup4
    - name: "安装运行环境2"
      run: pip install js2py
    - name: "安装运行环境3"
      run: pip install requests
    - name: "检查目录"
      run: ls
    - name: "TLD自动更新"
      run: python thelongdark.py
    - name: "开始更新壁纸"
      run: python py/wallpaper.py
    - name: "检查目录"
      run: ls
    - name: "提交更新"
      run: |
         git config --local user.email "2567810193@qq.com"
         git config --local user.name "Mnaisuka"
         git pull
         git add background/TheLongDark/*
         git add game/thelongdark/api/*
         git commit -m "update"
    - name: "推送更新"
      uses: ad-m/github-push-action@master
      with:
         github_token: ${{ secrets.my_token }}
         branch: main
  deploy: #--------------------
    permissions:
      contents: write
      pages: write
      id-token: write
    concurrency:
      group: "pages"
      cancel-in-progress: true
    needs: job_update
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2
      - name: Setup Pages
        uses: actions/configure-pages@v2
      - name: "拉取最新内容"
        run: |
          git config --local user.email "2567810193@qq.com"
          git config --local user.name "Mnaisuka"
          git pull
      - name: Upload artifact
        uses: actions/upload-pages-artifact@v1
        with:
          path: '.'
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v1