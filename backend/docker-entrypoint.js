import { spawn } from 'node:child_process'
import fs from 'node:fs'
import path from 'node:path'

const env = { ...process.env }

// If running the web server then migrate existing database
if (process.argv.slice(-2).join(' ') === 'bun src/main.ts') {
  await exec('bunx prisma generate')

  // ✅ Check and print the generated Prisma client path
  const expectedClientPath = path.resolve('src/generated/prisma/client.ts')
  if (fs.existsSync(expectedClientPath)) {
    console.log(`✅ Prisma client found at: ${expectedClientPath}`)
  } else {
    console.warn(`❌ Prisma client NOT found at: ${expectedClientPath}`)
  }

  const url = new URL(process.env.DATABASE_URL)
  const target = url.protocol === 'file:' && url.pathname
  await exec('bunx prisma migrate deploy')
}

// launch application
await exec(process.argv.slice(2).join(' '))

function exec(command) {
  const child = spawn(command, { shell: true, stdio: 'inherit', env })
  return new Promise((resolve, reject) => {
    child.on('exit', code => {
      if (code === 0) {
        resolve()
      } else {
        reject(new Error(`${command} failed rc=${code}`))
      }
    })
  })
}
