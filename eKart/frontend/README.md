# eKart Frontend

This directory contains the React.js application for the eKart marketplace. The UI includes:
- Login / Register pages
- Product catalog with search and categories
- Product detail view
- Shopping cart management
- Order history
- Admin dashboard (protected routes)

The app is built with **Create React App** and served through **NGINX** in production.

## Development
```bash
# Install dependencies
npm install

# Run locally (development server)
npm start
```

The development server runs on `http://localhost:3000` and proxies API calls to the backend (configurable via `proxy` in `package.json`).

## Build & Deploy
```bash
npm run build   # Creates static files in build/
```
The `Dockerfile` in this folder builds an NGINX image that serves the `build/` folder.

## Testing
- Unit tests: `npm test`
- Linting: `npm run lint`

## Security
- No secrets are stored in the source. Environment variables are injected at runtime via NGINX config or Kubernetes ConfigMaps.

---
For contribution guidelines, see the top‑level `README.md`.
