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

public class HttpPost<I, O> {

  /* Members */

  private String path;
  private HashSet<String> roles;
  private TypeToken<I> reqType;
  private TypeToken<O> respType;

  /* Constructors */

  public HttpPost(String path, HashSet<String> roles, TypeToken<I> reqType, TypeToken<O> respType) {
    this.path = Objects.requireNonNull(path);
    this.roles = Objects.requireNonNull(roles);
    this.reqType = Objects.requireNonNull(reqType);
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

  public TypeToken<I> getReqType() {
    return reqType;
  }

  public void setReqType(TypeToken<I> reqType) {
    this.reqType = Objects.requireNonNull(reqType);
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
    if (!(other0 instanceof HttpPost)) {
      return false;
    }
    HttpPost<?, ?> other = (HttpPost<?, ?>) other0;
    return
      path.equals(other.path) &&
      roles.equals(other.roles) &&
      reqType.equals(other.reqType) &&
      respType.equals(other.respType);
  }

  @Override
  public int hashCode() {
    int _result = 1;
    _result = _result * 37 + path.hashCode();
    _result = _result * 37 + roles.hashCode();
    _result = _result * 37 + reqType.hashCode();
    _result = _result * 37 + respType.hashCode();
    return _result;
  }

  /* Factory for construction of generic values */

  public static <I, O> Factory<HttpPost<I, O>> factory(Factory<I> factoryI, Factory<O> factoryO) {
    return new Factory<HttpPost<I, O>>() {
      final Lazy<Factory<String>> path = new Lazy<>(() -> Factories.STRING);
      final Lazy<Factory<HashSet<String>>> roles = new Lazy<>(() -> HashSetHelpers.factory(Factories.STRING));
      final Lazy<Factory<TypeToken<I>>> reqType = new Lazy<>(() -> Factories.typeProxy(factoryI));
      final Lazy<Factory<TypeToken<O>>> respType = new Lazy<>(() -> Factories.typeProxy(factoryO));

      @Override
      public HttpPost<I, O> create() {
        return new HttpPost<I, O>(
          path.get().create(),
          roles.get().create(),
          new TypeToken<I>(factoryI.jsonBinding()),
          new TypeToken<O>(factoryO.jsonBinding())
          );
      }

      @Override
      public HttpPost<I, O> create(HttpPost<I, O> other) {
        return new HttpPost<I, O>(
          other.getPath(),
          roles.get().create(other.getRoles()),
          other.getReqType(),
          other.getRespType()
          );
      }

      @Override
      public TypeExpr typeExpr() {
        ScopedName scopedName = new ScopedName("common.http", "HttpPost");
        ArrayList<TypeExpr> params = new ArrayList<>();
        params.add(factoryI.typeExpr());
        params.add(factoryO.typeExpr());
        return new TypeExpr(TypeRef.reference(scopedName), params);
      }

      @Override
      public JsonBinding<HttpPost<I, O>> jsonBinding() {
        return HttpPost.jsonBinding(factoryI.jsonBinding(), factoryO.jsonBinding());
      }
    };
  }

  /* Json serialization */

  public static<I, O> JsonBinding<HttpPost<I, O>> jsonBinding(JsonBinding<I> bindingI, JsonBinding<O> bindingO) {
    final Lazy<JsonBinding<String>> path = new Lazy<>(() -> JsonBindings.STRING);
    final Lazy<JsonBinding<HashSet<String>>> roles = new Lazy<>(() -> HashSetHelpers.jsonBinding(JsonBindings.STRING));
    final Lazy<JsonBinding<TypeToken<I>>> reqType = new Lazy<>(() -> JsonBindings.typeProxy(bindingI));
    final Lazy<JsonBinding<TypeToken<O>>> respType = new Lazy<>(() -> JsonBindings.typeProxy(bindingO));
    final Factory<I> factoryI = bindingI.factory();
    final Factory<O> factoryO = bindingO.factory();
    final Factory<HttpPost<I, O>> _factory = factory(bindingI.factory(), bindingO.factory());

    return new JsonBinding<HttpPost<I, O>>() {
      @Override
      public Factory<HttpPost<I, O>> factory() {
        return _factory;
      }

      @Override
      public JsonElement toJson(HttpPost<I, O> _value) {
        JsonObject _result = new JsonObject();
        _result.add("path", path.get().toJson(_value.path));
        _result.add("roles", roles.get().toJson(_value.roles));
        _result.add("reqType", reqType.get().toJson(_value.reqType));
        _result.add("respType", respType.get().toJson(_value.respType));
        return _result;
      }

      @Override
      public HttpPost<I, O> fromJson(JsonElement _json) {
        JsonObject _obj = JsonBindings.objectFromJson(_json);
        return new HttpPost<I, O>(
          JsonBindings.fieldFromJson(_obj, "path", path.get()),
          JsonBindings.fieldFromJson(_obj, "roles", roles.get()),
          _obj.has("reqType") ? JsonBindings.fieldFromJson(_obj, "reqType", reqType.get()) : new TypeToken<I>(bindingI),
          _obj.has("respType") ? JsonBindings.fieldFromJson(_obj, "respType", respType.get()) : new TypeToken<O>(bindingO)
        );
      }
    };
  }
}
