Feature: Delta Publishing

  Scenario: My first blog
    Given the file /package.json contains:
      """
      {
        "name": "my-first-blog",
        "version": "1.0.0",
        "dependencies": {
          "ejs": "2.5.6",
          "markdown": "0.5.0"
        }
      }
      """
    And the file /publish.js contains:
      """
      const fs = require('fs')
      const path = require('path')
      const markdown = require('markdown').markdown
      const EJS = require('ejs')
      const posts = require('./posts/*.md').map(postPath => {
        const rawMarkdown = fs.readFileSync(postPath)
        const parsedMarkdown = markdown.parse(rawMarkdown)
        return {
          slug: path.basename(postPath, '.md'),
          title: parsedMarkdown[1][2],
          html: markdown.toHTML(rawMarkdown)
        }
      })

      fs.writeFileSync(
        './public/index.html',
        new EJS({ url: './index.ejs' }).render({ posts })
      )

      posts.forEach(post => {
        fs.writeFileSync(`./public/posts/#{post.slug}/index.html`, post.html)
      })
      """
    And the file /index.ejs contains:
      """
      <html>
        <head>
          <title>My first blog</title>
        </head>
        <body>
          <h1>Posts</h1>
          <ul>
            <% for(var i = 0; i < posts.length; i++) { %>
              <li>
                <a href="posts/<%= posts[i].slug %>">
                  <%= posts[i].title %>
                </a>
              </li>
            <% } %>
          </ul>
        </body>
      </html>
      """
    And the file /posts/1.md contains:
      """
      # Hello world
      Wow, this is a delta published blog
      """
    Then my blog should be published!
