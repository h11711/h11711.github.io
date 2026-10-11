const fs = require('fs');
const path = require('path');

const SITE_URL = 'https://stevehuang.eu.org';
const AUTHOR_EMAIL = 'steveh11711@outlook.com';
const AUTHOR_NAME = 'Steve Huang';

// 读 articles.json
const articlesPath = path.join(process.cwd(), 'articles.json');
const articles = JSON.parse(fs.readFileSync(articlesPath, 'utf8'));

// 按日期倒序
articles.sort((a, b) => new Date(b.date) - new Date(a.date));

// 转 RFC 822 日期格式
function toRFC822(dateStr) {
    const d = new Date(dateStr + 'T00:00:00+08:00');
    return d.toUTCString().replace('GMT', '+0800');
}

// XML 转义
function esc(str) {
    return String(str || '')
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;');
}

// 构建 items
const items = articles.map(a => {
    const fullUrl = `${SITE_URL}/${a.url}`;
    const categories = (a.tags || []).map(t => `            <category>${esc(t)}</category>`).join('\n');
    return `        <item>
            <title>${esc(a.title)}</title>
            <link>${fullUrl}</link>
            <guid isPermaLink="true">${fullUrl}</guid>
            <pubDate>${toRFC822(a.date)}</pubDate>
            <author>${AUTHOR_EMAIL} (${AUTHOR_NAME})</author>
${categories}
            <description><![CDATA[
                ${a.excerpt || ''}
            ]]></description>
        </item>`;
}).join('\n\n');

const now = new Date().toUTCString().replace('GMT', '+0800');

const xml = `<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0"
     xmlns:atom="http://www.w3.org/2005/Atom"
     xmlns:content="http://purl.org/rss/1.0/modules/content/">

    <channel>
        <title>Steve的个人网站</title>
        <link>${SITE_URL}</link>
        <description>Steve Huang 的个人网站，记录学习、项目与思考。</description>
        <language>zh-CN</language>
        <lastBuildDate>${now}</lastBuildDate>
        <atom:link href="${SITE_URL}/rss/rss.xml" rel="self" type="application/rss+xml"/>

        <managingEditor>${AUTHOR_EMAIL} (${AUTHOR_NAME})</managingEditor>
        <webMaster>${AUTHOR_EMAIL} (${AUTHOR_NAME})</webMaster>

        <copyright>© ${new Date().getFullYear()} ${AUTHOR_NAME}. All Rights Reserved.</copyright>

${items}

    </channel>
</rss>
`;

// 写文件
const outPath = path.join(process.cwd(), 'rss', 'rss.xml');
fs.mkdirSync(path.dirname(outPath), { recursive: true });
fs.writeFileSync(outPath, xml, 'utf8');

console.log(`Generated rss.xml with ${articles.length} item(s).`);
