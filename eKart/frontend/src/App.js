// src/App.js
import React from 'react';
import { Routes, Route, Navigate } from 'react-router-dom';
import Login from './components/Login';
import Register from './components/Register';
import ProductList from './components/ProductList';
import ProductDetail from './components/ProductDetail';
import Cart from './components/Cart';
import OrderHistory from './components/OrderHistory';
import AdminDashboard from './components/AdminDashboard';

function App() {
  // Simple auth check placeholder – replace with real JWT logic
  const isAuthenticated = !!localStorage.getItem('token');
  const isAdmin = localStorage.getItem('role') === 'admin';

  return (
    <Routes>
      <Route path="/login" element={<Login />} />
      <Route path="/register" element={<Register />} />
      <Route path="/products" element={<ProductList />} />
      <Route path="/products/:id" element={<ProductDetail />} />
      <Route path="/cart" element={isAuthenticated ? <Cart /> : <Navigate to="/login" replace />} />
      <Route path="/orders" element={isAuthenticated ? <OrderHistory /> : <Navigate to="/login" replace />} />
      <Route path="/admin" element={isAdmin ? <AdminDashboard /> : <Navigate to="/login" replace />} />
      <Route path="*" element={<Navigate to="/products" replace />} />
    </Routes>
  );
}

export default App;
