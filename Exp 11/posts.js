import client from './client';

export async function fetchPosts() {
  const resp = await client.get('/posts');
  return resp.data;
}
