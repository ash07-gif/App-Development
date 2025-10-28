import axios from 'axios';

const client = axios.create({
  baseURL: 'https://jsonplaceholder.typicode.com',
  timeout: 8000
});

client.interceptors.response.use(
  (res) => res,
  (error) => {
    // You can normalize errors here
    return Promise.reject(error);
  }
);

export default client;
