---
name: instagram-search
description: Use Chrome DevTools to browse Instagram, search for accounts, hashtags, locations, and analyze competitors. Triggers when asked to search Instagram, look up accounts on IG, research competitors on Instagram, or browse Instagram for marketing research.
---

# Instagram Search Skill

Use Chrome DevTools to navigate and search Instagram for marketing research, competitor analysis, and audience discovery.

## Workflow

### Step 1 — Open Instagram
```bash
chrome-devtools__new_page(url="https://www.instagram.com/")
```

### Step 2 — Access Search
Click the **搜尋** (Search) icon in the left sidebar, OR navigate directly to the Explore page and click the search input.

### Step 3 — Enter Query
Type the search term into the search textbox. Use **Cantonese/Chinese terms** for HK-local content (e.g., `香港曲奇`, `香港手信`, `散水餅`) since English searches often return "no results" for HK-based accounts.

### Step 4 — Browse Results
Results appear in categories:
- **帳戶** (Accounts) — Instagram users/profiles
- **帖子** (Posts) — individual post content
- **標籤** (Hashtags) — hashtag pages
- **地點** (Locations) — geotagged locations

### Step 5 — Analyze Accounts
Click an account to view:
- Profile bio and description
- Number of posts, followers, following
- Recent posts and content style
- Engagement indicators (verified badge, etc.)

## Tips

- **HK Instagram quirk**: Direct URL navigation to search results (e.g., `/search?q=...`) often returns a 404. Always use the in-page search input instead.
- **Logged-in state**: If already logged in, the search bar is immediately accessible from the homepage sidebar.
- **Clear search**: Use the ✕ button to clear the search box before a new query.
- **Search categories**: Switch between tabs (Accounts / Posts / Tags / Places) to narrow results.
- **No results**: Try alternative terms. For HK cookies try: `曲奇`, `散水餅`, `香港手信`, `珍妮曲奇`, `手工曲奇`.

## Reference Data

For competitor research templates and result logging format, see:
- [references/competitor-research.md](references/competitor-research.md)
