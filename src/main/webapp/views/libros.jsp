<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Libros" />
<%@ include file="../components/header.jspf" %>

<div class="flex flex-col justify-between gap-4 sm:flex-row sm:items-end">
    <div><p class="text-sm font-bold uppercase tracking-widest text-indigo-600">Catálogo</p><h1 class="mt-1 font-display text-4xl font-bold text-slate-900">Libros</h1><p class="mt-2 text-slate-500">Busca y consulta el estado de cada ejemplar.</p></div>
    <a href="${pageContext.request.contextPath}/app/libros/nuevo" class="rounded-xl bg-indigo-600 px-5 py-3 text-center font-semibold text-white hover:bg-indigo-700">+ Registrar libro</a>
</div>
<c:if test="${param.ok == 'libro'}"><div class="mt-6 rounded-xl border border-emerald-200 bg-emerald-50 px-4 py-3 text-emerald-800">El libro se registró correctamente.</div></c:if>

<form method="get" action="${pageContext.request.contextPath}/app/libros" class="mt-8 flex gap-3">
    <input type="search" name="q" value="<c:out value='${busqueda}' />" placeholder="Buscar por título, autor o ISBN" class="min-w-0 flex-1 rounded-xl border border-stone-300 bg-white px-4 py-3 outline-none ring-indigo-200 focus:ring-4">
    <button class="rounded-xl bg-slate-900 px-5 py-3 font-semibold text-white hover:bg-slate-700">Buscar</button>
</form>

<div class="mt-6 overflow-hidden rounded-2xl border border-stone-200 bg-white shadow-sm">
    <div class="overflow-x-auto">
        <table class="w-full min-w-[700px] text-left text-sm">
            <thead class="bg-stone-100 text-xs uppercase tracking-wider text-slate-500"><tr><th class="px-6 py-4">Libro</th><th class="px-6 py-4">Autor</th><th class="px-6 py-4">ISBN</th><th class="px-6 py-4">Estado</th></tr></thead>
            <tbody class="divide-y divide-stone-100">
            <c:forEach var="libro" items="${libros}"><tr class="hover:bg-stone-50"><td class="px-6 py-4 font-semibold text-slate-900"><c:out value="${libro.titulo}" /></td><td class="px-6 py-4 text-slate-600"><c:out value="${libro.autor}" /></td><td class="px-6 py-4 font-mono text-xs text-slate-500"><c:out value="${libro.isbn}" /></td><td class="px-6 py-4"><span class="rounded-full px-3 py-1 text-xs font-bold ${libro.estado == 'DISPONIBLE' ? 'bg-emerald-50 text-emerald-700' : 'bg-amber-50 text-amber-700'}"><c:out value="${libro.estado}" /></span></td></tr></c:forEach>
            </tbody>
        </table>
    </div>
    <c:if test="${empty libros}"><p class="px-6 py-10 text-center text-slate-500">No se encontraron libros.</p></c:if>
</div>
<%@ include file="../components/footer.jspf" %>
