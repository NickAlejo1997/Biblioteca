<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set value="Préstamos" var="pageTitle"/>
<%@ include file="../components/header.jspf" %>

<div class="flex flex-col justify-between gap-4 sm:flex-row sm:items-end">
    <div><p class="text-sm font-bold uppercase tracking-widest text-indigo-600">Operaciones</p>
        <h1 class="mt-1 font-display text-4xl font-bold text-slate-900">Préstamos</h1>
        <p class="mt-2 text-slate-500">Controla los préstamos activos y consulta el historial.</p></div>
    <a class="rounded-xl bg-indigo-600 px-5 py-3 text-center font-semibold text-white hover:bg-indigo-700"
       href="${pageContext.request.contextPath}/app/prestamos/nuevo">+ Nuevo
        préstamo</a></div>
<c:if test="${param.ok == 'prestamo'}">
    <div class="mt-6 rounded-xl border border-emerald-200 bg-emerald-50 px-4 py-3 text-emerald-800">
        El préstamo se registró correctamente.
    </div>
</c:if>
<c:if test="${param.ok == 'devolucion'}">
    <div class="mt-6 rounded-xl border border-emerald-200 bg-emerald-50 px-4 py-3 text-emerald-800">
        La devolución se registró correctamente.
    </div>
</c:if>
<c:if test="${not empty error}">
    <div class="mt-6 rounded-xl border border-rose-200 bg-rose-50 px-4 py-3 text-rose-800">
        <c:out value="${error}"/>
    </div>
</c:if>

<section class="mt-8"><h2 class="mb-4 font-display text-2xl font-bold text-slate-900">Préstamos activos</h2>
    <div class="overflow-hidden rounded-2xl border border-stone-200 bg-white shadow-sm">
        <div class="overflow-x-auto">
            <table class="w-full min-w-[900px] text-left text-sm">
                <thead class="bg-stone-100 text-xs uppercase tracking-wider text-slate-500">
                <tr>
                    <th class="px-6 py-4">Libro</th>
                    <th class="px-6 py-4">Alumno</th>
                    <th class="px-6 py-4">Fecha</th>
                    <th class="px-6 py-4">Acción</th>
                </tr>
                </thead>
                <tbody class="divide-y divide-stone-100">
                <c:forEach items="${prestamosActivos}" var="p">
                    <tr>
                        <td class="px-6 py-4">
                            <p class="font-semibold text-slate-900">
                                <c:out value="${p.titulo}"/>
                            </p>
                            <p class="text-xs text-slate-500">
                                <c:out value="${p.autor}"/>
                            </p>
                        </td>
                        <td class="px-6 py-4">
                            <p class="font-medium">
                                <c:out value="${p.alumno}"/>
                            </p>
                            <p class="text-xs text-slate-500">
                                <c:out value="${p.codigoAlumno}"/>
                            </p>
                        </td>
                        <td class="px-6 py-4 text-slate-600">
                            <c:out value="${p.fechaPrestamo}"/>
                        </td>
                        <td class="px-6 py-4">
                            <form action="${pageContext.request.contextPath}/app/prestamos/devolver"
                                  class="flex items-center gap-2"
                                  method="post"><input name="idPrestamo" type="hidden"
                                                       value="${p.idPrestamo}">
                                <input class="rounded-lg border border-stone-300 px-2 py-2 text-xs" max="${hoy}"
                                       min="${p.fechaPrestamo}" name="fechaDevolucion" required type="date"
                                       value="${hoy}">
                                <button class="rounded-lg bg-emerald-600 px-3 py-2 text-xs font-bold text-white hover:bg-emerald-700">
                                    Devolver
                                </button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
        <c:if test="${empty prestamosActivos}"><p class="px-6 py-10 text-center text-slate-500">No hay préstamos
            activos.</p></c:if>
    </div>
</section>

<section class="mt-12"><h2 class="mb-4 font-display text-2xl font-bold text-slate-900">Historial</h2>
    <div class="overflow-hidden rounded-2xl border border-stone-200 bg-white shadow-sm">
        <div class="overflow-x-auto">
            <table class="w-full min-w-[800px] text-left text-sm">
                <thead class="bg-stone-100 text-xs uppercase tracking-wider text-slate-500">
                <tr>
                    <th class="px-6 py-4">Libro</th>
                    <th class="px-6 py-4">Alumno</th>
                    <th class="px-6 py-4">Préstamo</th>
                    <th class="px-6 py-4">Devolución</th>
                    <th class="px-6 py-4">Estado</th>
                </tr>
                </thead>
                <tbody class="divide-y divide-stone-100">
                <c:forEach items="${historial}" var="p">
                    <tr>
                        <td class="px-6 py-4 font-semibold">
                            <c:out value="${p.titulo}"/>
                        </td>
                        <td class="px-6 py-4">
                            <c:out value="${p.alumno}"/>
                        </td>
                        <td class="px-6 py-4 text-slate-600">
                            <c:out value="${p.fechaPrestamo}"/>
                        </td>
                        <td class="px-6 py-4 text-slate-600">
                            <c:out value="${p.fechaDevolucion}"/>
                        </td>
                        <td class="px-6 py-4">
                            <span class="rounded-full px-3 py-1 text-xs font-bold ${p.estado == 'DEVUELTO' ? 'bg-slate-100 text-slate-600' : 'bg-amber-50 text-amber-700'}">
                                <c:out value="${p.estado}"/>
                            </span>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
        <c:if test="${empty historial}">
            <p class="px-6 py-10 text-center text-slate-500">Todavía no hay historial.</p>
        </c:if>
    </div>
</section>
<%@ include file="../components/footer.jspf" %>
