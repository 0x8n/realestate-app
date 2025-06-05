import express from 'express'
import fs from 'fs'
import path from 'path'
import { fileURLToPath } from 'url'

const __filename = fileURLToPath(import.meta.url)
const __dirname = path.dirname(__filename)

const app = express()

// Serve static client assets
app.use('/assets', express.static(path.resolve(__dirname, 'dist/client/assets')))

app.get('*', async (req, res) => {
  const indexHtml = fs.readFileSync(
    path.resolve(__dirname, 'dist/client/index.html'),
    'utf-8'
  )

  // SSR entry from server bundle
  const { render } = await import(path.resolve(__dirname, 'dist/server/server.js'))
  const appHtml = await render(req.url)

  const html = indexHtml.replace(`<!--ssr-outlet-->`, appHtml)

  res.status(200).set({ 'Content-Type': 'text/html' }).end(html)
})

app.listen(3000, () => {
  console.log(`✅ SSR server running at http://localhost:3000`)
})
