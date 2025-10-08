<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  if (session == null || session.getAttribute("user") == null) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
  }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <title>Dashboard - Système Médical</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
<nav class="bg-teal-700 p-4 text-white">
  <div class="container mx-auto flex justify-between items-center">
    <h1 class="text-xl font-bold">Système Médical</h1>
    <div class="flex items-center gap-4">
      <span>Bienvenue, ${sessionScope.user} (${sessionScope.role})</span>
      <a href="logout" class="bg-white text-teal-700 px-4 py-2 rounded hover:bg-gray-100">
        Déconnexion
      </a>
    </div>
  </div>
</nav>

<div class="container mx-auto mt-8 p-4">
  <h2 class="text-2xl font-bold mb-4">Tableau de bord</h2>
  <p>Vous êtes connecté en tant que <strong>${sessionScope.role}</strong></p>
</div>
</body>
</html>
