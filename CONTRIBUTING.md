# Contributing to eRazOR

Thank you for your interest in contributing to eRazOR! This document provides guidelines for contributing.

## Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inspiring community for all. We pledge to:

- Be respectful and inclusive
- Accept constructive criticism
- Focus on what is best for the community
- Show empathy towards other community members

### Unacceptable Behavior

Unacceptable behavior includes:
- Harassment of any kind
- Discrimination
- Intimidation
- Personal attacks
- Unwelcome sexual advances

---

## How to Contribute

### 1. Report Bugs

Found a bug? Please open an issue with:

**Title**: Clear, descriptive bug title
**Description**:
```
**Describe the bug:**
[Clear description]

**To Reproduce:**
1. Step 1
2. Step 2
3. ...

**Expected behavior:**
[What should happen]

**Actual behavior:**
[What actually happened]

**Environment:**
- OS: [Windows/macOS/Linux]
- Docker version: [X.X.X]
- eRazOR version: [X.X.X]

**Logs/Screenshots:**
[Relevant logs or screenshots]
```

---

### 2. Suggest Enhancements

Have an idea? Open an issue with:

**Title**: `[FEATURE] Your feature suggestion`
**Description**:
```
**What problem does this solve?**
[Description]

**Proposed solution:**
[Your idea]

**Alternative solutions:**
[Other approaches]

**Additional context:**
[Any extra information]
```

---

### 3. Submit Code Changes

#### Step 1: Fork the Repository

1. Click **Fork** on GitHub
2. Clone your fork:
```bash
git clone https://github.com/YOUR-USERNAME/eRazOR.git
cd eRazOR
```

#### Step 2: Create a Branch

```bash
git checkout -b feature/your-feature-name
# or
git checkout -b fix/your-bug-fix
```

**Branch naming:**
- Features: `feature/description`
- Fixes: `fix/description`
- Docs: `docs/description`

#### Step 3: Make Changes

- Write clean, readable code
- Add comments for complex logic
- Follow Python PEP 8 style guide
- Test your changes thoroughly

#### Step 4: Commit Changes

```bash
git add .
git commit -m "Type: Clear description

Optional: Longer explanation if needed"
```

**Commit types:**
- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation
- `style:` Code style (no functional change)
- `refactor:` Code restructuring
- `test:` Adding/updating tests
- `chore:` Maintenance

#### Step 5: Push to Your Fork

```bash
git push origin feature/your-feature-name
```

#### Step 6: Open a Pull Request

1. Go to your fork on GitHub
2. Click **Compare & pull request**
3. Write PR description:

```
**Description:**
[What does this PR do?]

**Related Issue:**
Fixes #[issue number]

**Changes:**
- Change 1
- Change 2

**Testing:**
[How to test this change]

**Checklist:**
- [ ] Code follows style guidelines
- [ ] I've tested the changes
- [ ] Documentation updated
- [ ] No breaking changes
```

---

## Development Setup

### Clone and Setup

```bash
git clone https://github.com/Georgejomanga/eRazOR.git
cd eRazOR

# Create virtual environment
python3 -m venv venv
source venv/bin/activate  # Linux/macOS
# or
venv\Scripts\activate  # Windows

# Install development dependencies
pip install -r ai-assistant/requirements.txt
pip install pytest black pylint
```

### Running Tests

```bash
# Run all tests
pytest

# Run specific test
pytest tests/test_file.py

# Run with coverage
pytest --cov=ai_assistant tests/
```

### Code Style

```bash
# Format code
black ai-assistant/

# Check style
pylint ai-assistant/

# Check for issues
flake8 ai-assistant/
```

---

## File Structure

When adding files:

```
scripts/          - Bash/shell scripts
ai-assistant/     - Python AI code
  - cli.py        - Main CLI interface
  - modules/      - Feature modules
  - config.yaml   - Configuration
docs/             - Documentation
  - *.md          - Markdown files
configs/          - System configurations
tools-catalog/    - Tool lists
```

---

## Python Code Guidelines

### Style

```python
"""Module docstring."""

import os
import sys


class MyClass:
    """Class docstring."""
    
    def my_method(self, param):
        """Method docstring."""
        # Implementation
        pass


def my_function(param1, param2):
    """Function docstring."""
    # Implementation
    return result
```

### Security Considerations

- **No hardcoded credentials**
- **Sanitize user input**
- **Use parameterized queries**
- **Validate file paths**
- **Avoid command injection**
- **Log sensitive operations**

### Comments

```python
# Good comment - explains WHY, not WHAT
if user_role == 'admin':  # Admin users bypass verification
    skip_auth = True

# Bad comment - obvious
x = x + 1  # Increment x
```

---

## Documentation

### Writing Docs

- Clear and concise
- Use examples
- Include code blocks
- Link to related docs
- Update table of contents

### Doc Format

```markdown
# Heading

Clear description.

## Subheading

More details.

### Code Example

\`\`\`python
code here
\`\`\`

## See Also

- [Related doc](link)
```

---

## Review Process

### What Reviewers Look For

1. **Code Quality**
   - Clear and maintainable
   - Follows guidelines
   - No unnecessary complexity

2. **Functionality**
   - Works as intended
   - No regressions
   - Properly tested

3. **Documentation**
   - Updated if needed
   - Clear and accurate
   - Examples provided

4. **Security**
   - No vulnerabilities
   - Handles errors safely
   - Protects sensitive data

### Responding to Reviews

- Be open to feedback
- Ask clarifying questions
- Make requested changes
- Respond to all comments
- Thank reviewers!

---

## Release Process

### Version Numbering

We use Semantic Versioning: `MAJOR.MINOR.PATCH`

- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes (backward compatible)

### Release Steps

1. Update version in:
   - `README.md`
   - `cli.py`
   - `CHANGELOG.md`

2. Update `CHANGELOG.md` with changes

3. Create GitHub release with tag `v0.0.1`

4. Write release notes

---

## Getting Help

### Questions?

- Check existing issues
- Search documentation
- Ask in GitHub Discussions (coming soon)
- Review code examples

### Still Stuck?

Open an issue with `[QUESTION]` prefix!

---

## Recognition

Contributors will be recognized in:
- `CONTRIBUTORS.md` file
- Release notes
- Project documentation

---

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

## Thank You!

Every contribution, no matter how small, helps make eRazOR better. Thank you for being part of this project! 🎉

---

**Last Updated:** 2026-03-19
**Version:** 1.0
