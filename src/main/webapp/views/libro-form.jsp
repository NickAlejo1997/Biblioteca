<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Registrar libro" />
<%@ include file="../components/header.jspf" %>

<div class="mx-auto max-w-2xl"><a href="${pageContext.request.contextPath}/app/libros" class="text-sm font-semibold text-indigo-600">← Volver al catálogo</a><h1 class="mt-4 font-display text-4xl font-bold text-slate-900">Registrar libro</h1><p class="mt-2 text-slate-500">Agrega un nuevo título al catálogo disponible.</p>
<c:if test="${not empty error}"><div class="mt-6 rounded-xl border border-rose-200 bg-rose-50 px-4 py-3 text-rose-800"><c:out value="${error}" /></div></c:if>
<form method="post" action="${pageContext.request.contextPath}/app/libros/guardar" class="mt-8 space-y-5 rounded-2xl border border-stone-200 bg-white p-7 shadow-sm">
    <label class="block"><span class="mb-2 block text-sm font-semibold text-slate-700">Título</span><input required name="titulo" value="<c:out value='${libro.titulo}' />" class="w-full rounded-xl border border-stone-300 px-4 py-3 outline-none focus:border-indigo-500 focus:ring-4 focus:ring-indigo-100"></label>
    <label class="block"><span class="mb-2 block text-sm font-semibold text-slate-700">Autor</span><input required name="autor" value="<c:out value='${libro.autor}' />" class="w-full rounded-xl border border-stone-300 px-4 py-3 outline-none focus:border-indigo-500 focus:ring-4 focus:ring-indigo-100"></label>
    <label class="block"><span class="mb-2 block text-sm font-semibold text-slate-700">ISBN</span><input required name="isbn" value="<c:out value='${libro.isbn}' />" placeholder="978..." class="w-full rounded-xl border border-stone-300 px-4 py-3 outline-none focus:border-indigo-500 focus:ring-4 focus:ring-indigo-100"></label>
    <button class="w-full rounded-xl bg-indigo-600 px-5 py-3 font-semibold text-white hover:bg-indigo-700">Guardar libro</button>
</form></div>
<%@ include file="../components/footer.jspf" %>
