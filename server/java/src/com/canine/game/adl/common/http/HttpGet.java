/* @generated from adl module common.http */

package com.canine.game.adl.common.http;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import org.adl.runtime.Factories;
import org.adl.runtime.Factory;
import org.adl.runtime.HashSetHelpers;
import org.adl.runtime.JsonBinding;
import org.adl.runtime.JsonBindings;
import org.adl.runtime.Lazy;
import org.adl.runtime.TypeToken;
import org.adl.runtime.sys.adlast.ScopedName;
import org.adl.runtime.sys.adlast.TypeExpr;
import org.adl.runtime.sys.adlast.TypeRef;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Objects;

/**
 * New request types
 */
public class HttpGet<O> {

  /* Members */

  private String path;
  private HashSet<String> roles;
  private TypeToken<O> respType;

  /* Constructors */

  public HttpGet(String path, HashSet<String> roles, TypeToken<O> respType) {
    this.path = Objects.requireNonNull(path);
    this.roles = Objects.requireNonNull(roles);
    this.respType = Objects.requireNonNull(respType);
  }

  /* Accessors and mutators */

  public String getPath() {
    return path;
  }

  public void setPath(String path) {
    this.path = Objects.requireNonNull(path);
  }

  public HashSet<String> getRoles() {
    return roles;
  }

  public void setRoles(HashSet<String> roles) {
    this.roles = Objects.requireNonNull(roles);
  }

  public TypeToken<O> getRespType() {
    return respType;
  }

  public void setRespType(TypeToken<O> respType) {
    this.respType = Objects.requireNonNull(respType);
  }

  /* Object level helpers */

  @Override
  public boolean equals(Object other0) {
    if (!(other0 instanceof HttpGet)) {
      return false;
    }
    HttpGet<?> other = (HttpGet<?>) other0;
    return
      path.equals(other.path) &&
      roles.equals(other.roles) &&
      respType.equals(other.respType);
  }

  @Override
  public int hashCode() {
    int _result = 1;
    _result = _result * 37 + path.hashCode();
    _result = _result * 37 + roles.hashCode();
    _result = _result * 37 + respType.hashCode();
    return _result;
  }

  /* Factory for construction of generic values */

  public static <O> Factory<HttpGet<O>> factory(Factory<O> factoryO) {
    return new Factory<HttpGet<O>>() {
      final Lazy<Factory<String>> path = new Lazy<>(() -> Factories.STRING);
      final Lazy<Factory<HashSet<String>>> roles = new Lazy<>(() -> HashSetHelpers.factory(Factories.STRING));
      final Lazy<Factory<TypeToken<O>>> respType = new Lazy<>(() -> Factories.typeProxy(factoryO));

      @Override
      public HttpGet<O> create() {
        return new HttpGet<O>(
          path.get().create(),
          roles.get().create(),
          new TypeToken<O>(factoryO.jsonBinding())
          );
      }

      @Override
      public HttpGet<O> create(HttpGet<O> other) {
        return new HttpGet<O>(
          other.getPath(),
          roles.get().create(other.getRoles()),
          other.getRespType()
          );
      }

      @Override
      public TypeExpr typeExpr() {
        ScopedName scopedName = new ScopedName("common.http", "HttpGet");
        ArrayList<TypeExpr> params = new ArrayList<>();
        params.add(factoryO.typeExpr());
        return new TypeExpr(TypeRef.reference(scopedName), params);
      }

      @Override
      public JsonBinding<HttpGet<O>> jsonBinding() {
        return HttpGet.jsonBinding(factoryO.jsonBinding());
      }
    };
  }

  /* Json serialization */

  public static<O> JsonBinding<HttpGet<O>> jsonBinding(JsonBinding<O> bindingO) {
    final Lazy<JsonBinding<String>> path = new Lazy<>(() -> JsonBindings.STRING);
    final Lazy<JsonBinding<HashSet<String>>> roles = new Lazy<>(() -> HashSetHelpers.jsonBinding(JsonBindings.STRING));
    final Lazy<JsonBinding<TypeToken<O>>> respType = new Lazy<>(() -> JsonBindings.typeProxy(bindingO));
    final Factory<O> factoryO = bindingO.factory();
    final Factory<HttpGet<O>> _factory = factory(bindingO.factory());

    return new JsonBinding<HttpGet<O>>() {
      @Override
      public Factory<HttpGet<O>> factory() {
        return _factory;
      }

      @Override
      public JsonElement toJson(HttpGet<O> _value) {
        JsonObject _result = new JsonObject();
        _result.add("path", path.get().toJson(_value.path));
        _result.add("roles", roles.get().toJson(_value.roles));
        _result.add("respType", respType.get().toJson(_value.respType));
        return _result;
      }

      @Override
      public HttpGet<O> fromJson(JsonElement _json) {
        JsonObject _obj = JsonBindings.objectFromJson(_json);
        return new HttpGet<O>(
          JsonBindings.fieldFromJson(_obj, "path", path.get()),
          JsonBindings.fieldFromJson(_obj, "roles", roles.get()),
          _obj.has("respType") ? JsonBindings.fieldFromJson(_obj, "respType", respType.get()) : new TypeToken<O>(bindingO)
        );
      }
    };
  }
}
