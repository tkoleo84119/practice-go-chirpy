-- name: CreateChirp :one
INSERT INTO chirps (id, created_at, updated_at, body, user_id)
VALUES (
  gen_random_uuid (),
  NOW(),
  NOW(),
  $1,
  $2
)
RETURNING *;

-- name: GetChirps :many
SELECT * FROM chirps
WHERE 1 = 1
  AND ($1::uuid IS NULL OR user_id = $1)
ORDER BY created_at ASC;

-- name: GetChirpsByID :one
SELECT * FROM chirps
WHERE id = $1;

-- name: DeleteChirp :exec
DELETE FROM chirps
WHERE id = $1;