<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" encoding="UTF-8" indent="yes"/>
    
    <xsl:template match="/">
        <html lang="zh-CN">
            <head>
                <meta charset="UTF-8"/>
                <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
                <title>RSS Feed - <xsl:value-of select="rss/channel/title"/></title>
                <script src="https://cdn.tailwindcss.com"></script>
                <style>
                    @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&family=Noto+Sans+SC:wght@300;400;500;700&display=swap');
                    body { font-family: 'Inter', 'Noto Sans SC', sans-serif; background-color: #0a0a0a; color: #e5e5e5; }
                </style>
            </head>
            <body class="min-h-screen p-6 md:p-12">
                <div class="max-w-4xl mx-auto">
                    
                    <!-- 头部信息 -->
                    <header class="mb-12 pb-8 border-b border-neutral-800">
                        <div class="flex items-center gap-3 mb-4">
                            <div class="w-12 h-12 bg-orange-600 rounded-xl flex items-center justify-center">
                                <i class="fas fa-rss text-white text-2xl"></i>
                            </div>
                            <div>
                                <h1 class="text-3xl font-bold text-white">
                                    <xsl:value-of select="rss/channel/title"/>
                                </h1>
                                <p class="text-neutral-400 mt-1">
                                    <xsl:value-of select="rss/channel/description"/>
                                </p>
                            </div>
                        </div>
                        
                        <div class="flex flex-wrap gap-4 text-sm text-neutral-500">
                            <span>
                                <i class="fas fa-link mr-2"></i>
                                <a href="{rss/channel/link}" class="text-blue-400 hover:underline">
                                    <xsl:value-of select="rss/channel/link"/>
                                </a>
                            </span>
                            <span>
                                <i class="fas fa-clock mr-2"></i>
                                最后更新：<xsl:value-of select="rss/channel/lastBuildDate"/>
                            </span>
                            <span>
                                <i class="fas fa-envelope mr-2"></i>
                                <xsl:value-of select="rss/channel/webMaster"/>
                            </span>
                        </div>
                    </header>

                    <!-- 订阅提示 -->
                    <div class="bg-neutral-900 border border-neutral-800 rounded-xl p-6 mb-12">
                        <h2 class="text-xl font-bold text-white mb-3">订阅此 RSS 源</h2>
                        <p class="text-neutral-400 mb-4">
                            复制以下链接到你的 RSS 阅读器（如 Feedly、Inoreader、Reeder 等），即可实时获取最新文章更新。
                        </p>
                        <div class="flex gap-3">
                            <input type="text" 
                                   value="{rss/channel/atom:link/@href}" 
                                   readonly="readonly"
                                   class="flex-1 bg-black border border-neutral-700 rounded-lg px-4 py-3 text-sm text-neutral-300 select-all"/>
                            <button onclick="copyRssUrl()" 
                                    class="px-6 py-3 bg-white text-black rounded-lg font-semibold hover:bg-neutral-200 transition-colors">
                                复制链接
                            </button>
                        </div>
                    </div>

                    <!-- 文章列表 -->
                    <div class="space-y-8">
                        <h2 class="text-2xl font-bold text-white mb-6">最新文章</h2>
                        
                        <xsl:for-each select="rss/channel/item">
                            <article class="bg-neutral-900 border border-neutral-800 rounded-xl p-6 hover:border-neutral-600 transition-colors">
                                <div class="flex flex-wrap gap-2 mb-3">
                                    <xsl:for-each select="category">
                                        <span class="px-2 py-1 bg-neutral-800 rounded text-xs text-neutral-400">
                                            <xsl:value-of select="."/>
                                        </span>
                                    </xsl:for-each>
                                </div>
                                
                                <h3 class="text-xl font-bold text-white mb-2">
                                    <a href="{link}" class="hover:text-neutral-300 transition-colors">
                                        <xsl:value-of select="title"/>
                                    </a>
                                </h3>
                                
                                <p class="text-neutral-400 mb-4 line-clamp-2">
                                    <xsl:value-of select="description" disable-output-escaping="yes"/>
                                </p>
                                
                                <div class="flex items-center justify-between text-sm text-neutral-500">
                                    <span>
                                        <i class="far fa-calendar mr-2"></i>
                                        <xsl:value-of select="pubDate"/>
                                    </span>
                                    <a href="{link}" class="text-blue-400 hover:underline flex items-center gap-2">
                                        阅读全文
                                        <i class="fas fa-arrow-right text-xs"></i>
                                    </a>
                                </div>
                            </article>
                        </xsl:for-each>
                    </div>

                    <!-- 页脚 -->
                    <footer class="mt-16 pt-8 border-t border-neutral-800 text-center text-neutral-500 text-sm">
                        <p>
                            <xsl:value-of select="rss/channel/copyright"/>
                        </p>
                        <p class="mt-2">
                            使用 RSS 2.0 格式生成
                        </p>
                    </footer>

                </div>

                <script>
                    function copyRssUrl() {
                        const input = document.querySelector('input');
                        input.select();
                        document.execCommand('copy');
                        alert('RSS 链接已复制到剪贴板');
                    }
                </script>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
