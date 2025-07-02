-- name: CreateRefreshToken :one
INSERT INTO refresh_tokens (created_at, updated_at, user_id, token, expires_at)
VALUES (
  NOW(),
  NOW(),
  $1,
  $2,
  $3
)
RETURNING *;

-- name: RevokeRefreshToken :one
UPDATE refresh_tokens
SET revoked_at = NOW(),
  updated_at = NOW()
WHERE token = $1
RETURNING *;

-- name: GetUserFromRefreshToken :one
SELECT * FROM refresh_tokens
JOIN users ON users.id = refresh_tokens.user_id
WHERE refresh_tokens.token = $1
AND refresh_tokens.revoked_at IS NULL
AND refresh_tokens.expires_at > NOW();
