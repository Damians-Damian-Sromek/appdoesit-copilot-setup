# Form Security Checklist

Security implementation requirements for forms in AppDoesIt apps.

**Source:** AGENTS.md `### Form Security (MANDATORY)` section.

---

## When to Apply

Apply these protections to ALL forms that:
- Submit data to the server
- Send emails
- Write to database
- Process user input

---

## 1. CSRF Protection

### Implementation

**Session initialization (in bootstrap):**
```php
if (empty($_SESSION['csrf_token'])) {
    $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
}
```

**In form HTML:**
```php
<form method="POST" action="<?= e($formAction) ?>">
    <input type="hidden" name="csrf_token" value="<?= e($_SESSION['csrf_token']) ?>">
    <!-- Form fields -->
</form>
```

**Server-side validation:**
```php
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Validate CSRF token
    if (!hash_equals($_SESSION['csrf_token'], $_POST['csrf_token'] ?? '')) {
        http_response_code(403);
        exit('Invalid request');
    }

    // Process form...
}
```

### Checklist
- [ ] Token generated per session
- [ ] Token included as hidden field
- [ ] Token validated with `hash_equals()`
- [ ] Invalid requests return 403

---

## 2. Honeypot Fields

### Implementation

**In form HTML:**
```php
<!-- Honeypot field - hidden via CSS, NOT type="hidden" -->
<div class="honeypot-field" aria-hidden="true">
    <label for="website_url">Website (leave blank)</label>
    <input type="text"
           name="website_url"
           id="website_url"
           tabindex="-1"
           autocomplete="off">
</div>
```

**CSS to hide (in stylesheet):**
```css
.honeypot-field {
    position: absolute;
    left: -9999px;
    top: -9999px;
    opacity: 0;
    pointer-events: none;
}
```

**Server-side validation:**
```php
if (!empty($_POST['website_url'])) {
    http_response_code(403);
    exit('Bot detected');
}
```

### Why Not type="hidden"?
Bots detect `type="hidden"` and skip those fields. CSS-hidden fields look real to bots.

### Checklist
- [ ] Honeypot field uses CSS hiding (not type="hidden")
- [ ] Field has `tabindex="-1"` (skip in tab order)
- [ ] Field has `autocomplete="off"`
- [ ] Field has `aria-hidden="true"`
- [ ] Server rejects if field is filled

---

## 3. Time-Based Validation

### Implementation

**In form HTML:**
```php
<input type="hidden" name="form_time" value="<?= time() ?>">
```

**Server-side validation:**
```php
$submissionTime = time() - (int)($_POST['form_time'] ?? 0);

// Reject if submitted in less than 3 seconds
if ($submissionTime < 3) {
    http_response_code(403);
    exit('Submission too fast');
}

// Optional: Reject if form is too old (e.g., > 1 hour)
if ($submissionTime > 3600) {
    http_response_code(403);
    exit('Form expired');
}
```

### Checklist
- [ ] Timestamp added as hidden field
- [ ] Submissions < 3 seconds rejected
- [ ] Optional: Expired forms rejected

---

## 4. Input Validation & Sanitization

### Email Validation

```php
$email = $_POST['email'] ?? '';

if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    $errors['email'] = 'Invalid email address';
}
```

### Text Length Limits

```php
$name = $_POST['name'] ?? '';

if (strlen($name) > 100) {
    $errors['name'] = 'Name too long (max 100 characters)';
}
```

### Output Escaping

**Always use `e()` helper for output:**
```php
// CORRECT
<p>Hello, <?= e($name) ?>!</p>

// INCORRECT - XSS vulnerability
<p>Hello, <?= $name ?>!</p>
```

### Checklist
- [ ] Emails validated with `FILTER_VALIDATE_EMAIL`
- [ ] Text inputs have max length limits
- [ ] All output escaped with `e()`
- [ ] No raw user input in HTML

---

## Complete Form Example

```php
<?php
$errors = [];
$success = false;

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // 1. CSRF validation
    if (!hash_equals($_SESSION['csrf_token'], $_POST['csrf_token'] ?? '')) {
        http_response_code(403);
        exit('Invalid request');
    }

    // 2. Honeypot check
    if (!empty($_POST['website_url'])) {
        http_response_code(403);
        exit('Bot detected');
    }

    // 3. Time-based validation
    if (time() - (int)($_POST['form_time'] ?? 0) < 3) {
        http_response_code(403);
        exit('Submission too fast');
    }

    // 4. Input validation
    $name = trim($_POST['name'] ?? '');
    $email = trim($_POST['email'] ?? '');
    $message = trim($_POST['message'] ?? '');

    if (empty($name) || strlen($name) > 100) {
        $errors['name'] = 'Name is required (max 100 chars)';
    }

    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        $errors['email'] = 'Valid email is required';
    }

    if (empty($message) || strlen($message) > 1000) {
        $errors['message'] = 'Message is required (max 1000 chars)';
    }

    // Process if no errors
    if (empty($errors)) {
        // Send email, save to database, etc.
        $success = true;
    }
}
?>

<form method="POST" action="">
    <input type="hidden" name="csrf_token" value="<?= e($_SESSION['csrf_token']) ?>">
    <input type="hidden" name="form_time" value="<?= time() ?>">

    <!-- Honeypot -->
    <div class="honeypot-field" aria-hidden="true">
        <input type="text" name="website_url" tabindex="-1" autocomplete="off">
    </div>

    <div class="form-group">
        <label for="name">Name</label>
        <input type="text" id="name" name="name"
               value="<?= e($name ?? '') ?>"
               maxlength="100" required>
        <?php if (isset($errors['name'])): ?>
            <span class="error"><?= e($errors['name']) ?></span>
        <?php endif; ?>
    </div>

    <div class="form-group">
        <label for="email">Email</label>
        <input type="email" id="email" name="email"
               value="<?= e($email ?? '') ?>" required>
        <?php if (isset($errors['email'])): ?>
            <span class="error"><?= e($errors['email']) ?></span>
        <?php endif; ?>
    </div>

    <div class="form-group">
        <label for="message">Message</label>
        <textarea id="message" name="message"
                  maxlength="1000" required><?= e($message ?? '') ?></textarea>
        <?php if (isset($errors['message'])): ?>
            <span class="error"><?= e($errors['message']) ?></span>
        <?php endif; ?>
    </div>

    <button type="submit">Submit</button>

    <?php if ($success): ?>
        <p class="success">Thank you! Your message has been sent.</p>
    <?php endif; ?>
</form>
```

---

## Security Checklist Summary

| Protection | Required | Status |
|------------|----------|--------|
| CSRF token | Yes | [ ] |
| Honeypot field | Yes | [ ] |
| Time validation | Yes | [ ] |
| Email validation | If email field | [ ] |
| Length limits | Yes | [ ] |
| Output escaping | Yes | [ ] |
