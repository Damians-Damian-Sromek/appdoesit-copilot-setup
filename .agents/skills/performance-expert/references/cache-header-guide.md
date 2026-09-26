# HTTP Cache Header Guide

Reference guide for HTTP caching directives on AppDoesIt (OVH shared hosting).

## Cache-Control Directives

### Common Directives

| Directive | Description |
|-----------|-------------|
| `public` | Response can be cached by browsers and proxies |
| `private` | Response can only be cached by browsers (not proxies) |
| `no-cache` | Must revalidate with server before using cached copy |
| `no-store` | Never cache (sensitive data) |
| `max-age=N` | Cache is valid for N seconds |
| `must-revalidate` | Stale cache must revalidate before use |
| `immutable` | Content will never change (use with versioned URLs) |

### Recommended Headers by Content Type

#### HTML Pages (Dynamic Content)
```
Cache-Control: no-cache, must-revalidate
Vary: Accept-Encoding, Accept-Language
```
- Content may change
- Must revalidate on each visit
- Vary header ensures correct version per locale/encoding

#### CSS/JS Files (Static with Cache Busting)
```
Cache-Control: public, max-age=31536000, immutable
```
- Cache for 1 year (31536000 seconds)
- `immutable` prevents revalidation
- Cache busting via `?v=VERSION` query string

#### Images (Static)
```
Cache-Control: public, max-age=31536000
```
- Cache for 1 year
- Use WebP format when possible

#### Fonts (Static)
```
Cache-Control: public, max-age=31536000
```
- Cache for 1 year
- WOFF2 preferred format

#### JSON Data Files
```
Cache-Control: no-cache, must-revalidate
```
- May contain dynamic data
- Revalidate on each request

#### i18n Translation Files
```
Cache-Control: public, max-age=86400
```
- Cache for 1 day
- Updated via deployment

---

## Verifying Headers

### Using curl

```bash
# Check HTML page headers
curl -I http://localhost:8000/apps/calculator

# Check static asset headers
curl -I http://localhost:8000/assets/css/main.css

# Check with compression
curl -H "Accept-Encoding: gzip" -I http://localhost:8000/apps/calculator
```

### Expected Output

**HTML Page:**
```
HTTP/1.1 200 OK
Cache-Control: no-cache, must-revalidate
Vary: Accept-Encoding, Accept-Language
Content-Encoding: gzip
Content-Type: text/html; charset=UTF-8
```

**Static Asset:**
```
HTTP/1.1 200 OK
Cache-Control: public, max-age=31536000
Content-Encoding: gzip
Content-Type: text/css; charset=UTF-8
```

---

## Implementation Locations

### 1. Apache .htaccess (Already Configured)

File: `public/.htaccess`

```apache
# Browser caching via mod_expires
<IfModule mod_expires.c>
    ExpiresActive On
    ExpiresByType text/html "access plus 0 seconds"
    ExpiresByType text/css "access plus 1 year"
    ExpiresByType application/javascript "access plus 1 year"
    ExpiresByType image/jpeg "access plus 1 year"
    ExpiresByType image/png "access plus 1 year"
    ExpiresByType image/webp "access plus 1 year"
</IfModule>

# GZIP compression via mod_deflate
<IfModule mod_deflate.c>
    AddOutputFilterByType DEFLATE text/html text/plain text/css
    AddOutputFilterByType DEFLATE application/json application/javascript
    AddOutputFilterByType DEFLATE image/svg+xml
</IfModule>
```

### 2. PHP Headers (For Dynamic Content)

File: `public/index.php`

```php
// For HTML pages
header('Cache-Control: no-cache, must-revalidate');
header('Vary: Accept-Encoding, Accept-Language');

// For API/JSON responses
header('Cache-Control: no-store, no-cache, must-revalidate');
```

---

## Vary Header

The `Vary` header tells caches which request headers affect the response:

```
Vary: Accept-Encoding, Accept-Language
```

**Why it matters:**
- `Accept-Encoding`: Different responses for gzip vs uncompressed
- `Accept-Language`: Different responses per locale (important for i18n)

---

## Cache Busting

AppDoesIt uses query string versioning:

```php
// app/helpers.php
function asset($path) {
    $version = @file_get_contents(dirname(__DIR__) . '/VERSION') ?: time();
    return url('/assets/' . ltrim($path, '/')) . '?v=' . trim($version);
}
```

**Usage:**
```html
<link rel="stylesheet" href="<?= asset('css/main.css') ?>">
<!-- Output: /assets/css/main.css?v=1.2.3 -->
```

**Benefits:**
- Long cache max-age (1 year)
- New version = new URL = fresh download
- No stale assets after deployment

---

## OVH Shared Hosting Notes

1. **mod_expires**: Available and configured
2. **mod_deflate**: Available and configured
3. **mod_headers**: Available for custom headers
4. **ETags**: Disabled in .htaccess (reduces revalidation overhead)
5. **No server-side caching**: No Redis/Memcached available

---

## Troubleshooting

### Headers Not Applied

1. Check `.htaccess` is being read:
   ```bash
   curl -I http://localhost:8000/test-htaccess-missing
   # Should return 404, not directory listing
   ```

2. Verify Apache modules enabled:
   ```bash
   # In Docker container
   apache2ctl -M | grep -E "expires|deflate|headers"
   ```

### GZIP Not Working

1. Check Accept-Encoding header is sent:
   ```bash
   curl -H "Accept-Encoding: gzip" -I http://localhost:8000/
   ```

2. Verify Content-Encoding in response:
   ```
   Content-Encoding: gzip
   ```

### Cache Not Invalidating

1. Bump VERSION file
2. Clear browser cache
3. Use `?v=` cache buster for assets
