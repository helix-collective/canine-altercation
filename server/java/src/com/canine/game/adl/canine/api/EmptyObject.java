/* @generated from adl module canine.api */

package com.canine.game.adl.canine.api;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import org.adl.runtime.Factory;
import org.adl.runtime.JsonBinding;
import org.adl.runtime.JsonBindings;
import org.adl.runtime.Lazy;
import org.adl.runtime.sys.adlast.ScopedName;
import org.adl.runtime.sys.adlast.TypeExpr;
import org.adl.runtime.sys.adlast.TypeRef;
import java.util.ArrayList;
import java.util.Objects;

public class EmptyObject {


  /* Constructors */

  public EmptyObject() {
  }

  public EmptyObject(EmptyObject other) {
  }

  /* Object level helpers */

  @Override
  public boolean equals(Object other) {
    return other instanceof EmptyObject;
  }

  @Override
  public int hashCode() {
    int _result = 1;
    return _result;
  }

  /* Factory for construction of generic values */

  public static final Factory<EmptyObject> FACTORY = new Factory<EmptyObject>() {
    @Override
    public EmptyObject create() {
      return new EmptyObject();
    }

    @Override
    public EmptyObject create(EmptyObject other) {
      return new EmptyObject(other);
    }

    @Override
    public TypeExpr typeExpr() {
      ScopedName scopedName = new ScopedName("canine.api", "EmptyObject");
      ArrayList<TypeExpr> params = new ArrayList<>();
      return new TypeExpr(TypeRef.reference(scopedName), params);
    }
    @Override
    public JsonBinding<EmptyObject> jsonBinding() {
      return EmptyObject.jsonBinding();
    }
  };

  /* Json serialization */

  public static JsonBinding<EmptyObject> jsonBinding() {
    final Factory<EmptyObject> _factory = FACTORY;

    return new JsonBinding<EmptyObject>() {
      @Override
      public Factory<EmptyObject> factory() {
        return _factory;
      }

      @Override
      public JsonElement toJson(EmptyObject _value) {
        JsonObject _result = new JsonObject();
        return _result;
      }

      @Override
      public EmptyObject fromJson(JsonElement _json) {
        JsonObject _obj = JsonBindings.objectFromJson(_json);
        return new EmptyObject(
        );
      }
    };
  }
}
